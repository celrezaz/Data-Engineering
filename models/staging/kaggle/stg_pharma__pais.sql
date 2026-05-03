with 

source as (

    select 
        country
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        country,
        cast(md5(lower(trim(cast(country as varchar)))) as varchar) AS country_id

    from source

)

select * from renamed