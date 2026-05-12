with

seed as (
    select
        product_name,
        product_class
    from {{ ref('canonical_product_class') }}
),

source as (
    select
        trim(TO_VARCHAR(product_name))  as product_name_raw,
        case
            when lower(trim(TO_VARCHAR(product_class))) in ('NA','na', '') then null
            else trim(TO_VARCHAR(product_class))
        end                                                            as product_class,
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_coste), ',', '.'), 10, 3) as precio_coste,
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_venta), ',', '.'), 10, 3) as precio_venta,
        fecha
    from {{ source('kaggle', 'farmacia') }}
),

source_producto_class as (
    select distinct
        trim(TO_VARCHAR(product_name))                                 as product_name,
        case
            when lower(trim(TO_VARCHAR(product_class))) in ('NA','na', '') then null
            else trim(TO_VARCHAR(product_class))
        end                                                            as product_class
    from {{ source('kaggle', 'farmacia') }}
),

precios as (
    select distinct
        product_name_raw                                               as product_name,
        precio_coste,
        precio_venta,
        MIN(fecha) OVER (
            PARTITION BY product_name_raw, precio_coste, precio_venta
        )                                                              as valid_from
    from source
),

versiones as (
    select distinct
        product_name,
        precio_coste,
        precio_venta,
        valid_from,
        LEAD(valid_from) OVER (
            PARTITION BY product_name
            ORDER BY valid_from
        )                                                              as next_valid_from
    from precios
),

rangos as (
    select
        product_name,
        precio_coste,
        precio_venta,
        valid_from,
        case
            when next_valid_from is null then null
            else DATEADD(day, -1, next_valid_from)
        end                                                            as valid_to
    from versiones
),

enriched as (
    select
        r.product_name,
        COALESCE(spc.product_class, seed.product_class)               as product_class,
        r.precio_coste,
        r.precio_venta,
        r.valid_from,
        r.valid_to
    from rangos r
    left join source_producto_class spc
        on lower(trim(r.product_name)) = lower(trim(spc.product_name))
    left join seed
        on lower(trim(r.product_name)) = lower(trim(seed.product_name))
),

cleaned as (
    select distinct
        case
            when lower(trim(product_name)) in ('na', '') then 'Unknown'
            else COALESCE(product_name, 'Unknown')
        end                                                            as product_name,
        COALESCE(product_class, 'Unknown')                            as product_class,
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
        {{ dbt_utils.generate_surrogate_key(['product_class']) }}              as product_class_id,
        precio_coste,
        precio_venta,
        valid_from,
        valid_to,
        case
            when valid_to is null then true
            else false
        end                                                                    as is_current
    from cleaned
)

select * from renamed