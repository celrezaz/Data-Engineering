with 

source as (

    select 
        city,
        country,
        latitude,
        longitude
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        cast(md5(lower(trim(cast(city as varchar)))) as varchar) AS city_id,
        city,
        latitude,
        longitude, 
        cast(md5(lower(trim(cast(country as varchar)))) as varchar) AS country_id

    from source

)

select * from renamed