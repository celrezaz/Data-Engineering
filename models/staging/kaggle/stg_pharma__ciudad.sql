with 

source as (

    select 
        city,
        {{ dbt_utils.generate_surrogate_key(['city']) }} as city_id,
        {{ dbt_utils.generate_surrogate_key(['country']) }} as country_id,
        {{ mayusculas_nombres('country') }} AS country,
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct *

    from source

)

select * from renamed