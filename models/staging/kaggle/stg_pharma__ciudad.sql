with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(city))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE(city, 'Unknown')
        end as city,
        case
            when lower(trim(TO_VARCHAR(country))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE({{ mayusculas_nombres('country') }}, 'Unknown')
        end as country
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as city,
        'Unknown' as country

),

renamed as (

    select distinct
        city,
        {{ dbt_utils.generate_surrogate_key(['city']) }}     as city_id,
        country,
        {{ dbt_utils.generate_surrogate_key(['country']) }}  as country_id
    from source

)

select * from renamed