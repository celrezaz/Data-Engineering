with

seed as (

    select
        product_name,
        product_class
    from {{ ref('canonical_product_class') }}

),

source as (

    select
        trim(TO_VARCHAR(product_name)) as product_name_raw,
        case
            when lower(trim(TO_VARCHAR(product_class))) in ('NA','na', '') then null
            else COALESCE(trim(TO_VARCHAR(product_class)), null)
        end as product_class,
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_coste), ',', '.'), 10, 3) as precio_coste,
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_venta), ',', '.'), 10, 3) as precio_venta,
        MIN(fecha) OVER (
            PARTITION BY product_name, precio_coste, precio_venta
        ) as valid_from,
        MAX(fecha) OVER (
            PARTITION BY product_name, precio_coste, precio_venta
        ) as valid_to
    from {{ source('kaggle', 'farmacia') }}

),

enriched as (

    select
        s.product_name_raw,
        COALESCE(s.product_class, seed.product_class) as product_class,
        s.precio_coste,
        s.precio_venta,
        s.valid_from,
        s.valid_to
    from source s
    left join seed on lower(trim(s.product_name_raw)) = lower(trim(seed.product_name))

),

cleaned as (

    select
        case
            when lower(trim(product_name_raw)) in ('NA', 'na', '') then 'Unknown'
            else COALESCE(product_name_raw, 'Unknown')
        end as product_name,
        COALESCE(product_class, 'Unknown') as product_class,
        precio_coste,
        precio_venta,
        valid_from,
        valid_to
    from enriched

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['product_name', 'valid_from']) }} as pk_product,
        product_name,
        {{ dbt_utils.generate_surrogate_key(['product_name']) }}               as product_id,
        {{ dbt_utils.generate_surrogate_key(['product_class']) }}               as product_class_id,
        precio_coste,
        precio_venta,
        valid_from,
        case
            when valid_to = MAX(valid_to) OVER (PARTITION BY product_name)
            then null
            else valid_to
        end as valid_to
    from cleaned

)

select distinct * from renamed