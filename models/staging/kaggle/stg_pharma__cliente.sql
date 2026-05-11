with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(customer_name))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE(customer_name, 'Unknown')
        end as customer_name,
        case
            when lower(trim(TO_VARCHAR(city))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE(city, 'Unknown')
        end as city,
        cast(latitude as decimal(18,5)) as latitude,
        cast(longitude as decimal(18,5)) as longitude
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as customer_name,
        'Unknown' as city,
        null      as latitude,
        null      as longitude

),

renamed as (

    select distinct
        customer_name,
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }} as customer_id,
        {{ dbt_utils.generate_surrogate_key(['city']) }}          as city_id,
        latitude,
        longitude
    from source

)

select * from renamed