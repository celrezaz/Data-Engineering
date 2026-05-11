with

canonical as (
    select name from {{ ref('canonical_sales_reps') }}
),

source as (

    select
        case
            when lower(trim(TO_VARCHAR(o.distributor))) in ('na', '') then 'Unknown'
            else COALESCE({{ mayusculas_nombres('o.distributor') }}, 'Unknown')
        end as distributor,
        case
            when lower(trim(TO_VARCHAR(o.customer_name))) in ('na', '') then 'Unknown'
            else COALESCE(trim(TO_VARCHAR(o.customer_name)), 'Unknown')
        end as customer_name,
        case
            when lower(trim(TO_VARCHAR(o.subchannel))) in ('na', '') then 'Unknown'
            else COALESCE(trim(TO_VARCHAR(o.subchannel)), 'Unknown')
        end as subchannel,
        case
            when lower(trim(TO_VARCHAR(o.product_name))) in ('na', '') then 'Unknown'
            else COALESCE(trim(TO_VARCHAR(o.product_name)), 'Unknown')
        end as product_name,
        case
            when lower(trim(TO_VARCHAR(o.name_sales_rep))) in ('na', '') then 'Unknown'
            when o.name_sales_rep is null                                 then 'Unknown'
            else c.name
        end as name_sales_rep_clean,
        case
            when o.fecha is null then '1900-01-01'::date
            when lower(trim(TO_VARCHAR(o.fecha))) in ('na', '') then '1900-01-01'::date
            else o.fecha
        end as fecha,
        cast(o.quantity as decimal(10,3)) as quantity

    from {{ source('kaggle', 'farmacia') }} o
    left join canonical c on true
    qualify row_number() over (
        partition by o.name_sales_rep, o.fecha, o.customer_name, o.product_name, o.distributor, o.subchannel, o.quantity
        order by case
            when lower(trim(TO_VARCHAR(o.name_sales_rep))) in ('na', '') or o.name_sales_rep is null
                then 0
            else JAROWINKLER_SIMILARITY(
                lower(trim(REGEXP_REPLACE(TO_VARCHAR(o.name_sales_rep), '[^a-zA-Z0-9 ]', ''))),
                lower(c.name)
            )
        end desc
    ) = 1
    and (
        lower(trim(TO_VARCHAR(o.name_sales_rep))) in ('na', '')
        or o.name_sales_rep is null
        or JAROWINKLER_SIMILARITY(
            lower(trim(REGEXP_REPLACE(TO_VARCHAR(o.name_sales_rep), '[^a-zA-Z0-9 ]', ''))),
            lower(c.name)
        ) > 0.85
    )

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['fecha', 'name_sales_rep_clean', 'customer_name', 'product_name', 'distributor', 'subchannel', 'quantity']) }} as linea_venta_id,
        {{ dbt_utils.generate_surrogate_key(['fecha', 'name_sales_rep_clean', 'customer_name']) }}                                                           as venta_id,
        {{ dbt_utils.generate_surrogate_key(['distributor']) }}        as distributor_id,
        {{ dbt_utils.generate_surrogate_key(['product_name']) }}       as product_id,
        {{ dbt_utils.generate_surrogate_key(['subchannel']) }}         as subchannel_id,
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }}      as customer_id,
        fecha,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean']) }} as sales_rep_id,
        quantity
    from source

)

select * from renamed