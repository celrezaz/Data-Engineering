with

source as (

    select
        product_name,
        case
            when lower(trim(TO_VARCHAR(product_class))) in ('NA', 'na', '') then null
            else COALESCE(trim(TO_VARCHAR(product_class)), null)
        end as product_class
    from {{ source('kaggle', 'farmacia') }}

),

seed as (

    select
        product_name,
        product_class
    from {{ ref('canonical_product_class') }}

),

enriched as (

    select
        s.product_name,
        COALESCE(s.product_class, seed.product_class) as product_class
    from source s
    left join seed on lower(trim(s.product_name)) = lower(trim(seed.product_name))

),

cleaned as (

    select
        {{ mayusculas_nombres('product_class') }} as product_class
    from enriched
    
),

renamed as (

    select 
        COALESCE(product_class, 'Unknown')                          as product_class,
        {{ dbt_utils.generate_surrogate_key(['product_class']) }}   as product_class_id
    from cleaned

    union all

    select
        'Unknown'                                               as product_class,
        {{ dbt_utils.generate_surrogate_key(['\'Unknown\'']) }} as product_class_id

)

select distinct * from renamed