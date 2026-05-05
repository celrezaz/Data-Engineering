with 

source as (

    select 
        city,
        {{ crear_id(['city']) }} as city_id,
        {{ crear_id(['country']) }} as country_id,
        {{ mayusculas_nombres('country') }} AS country,
        cast(latitude as decimal (18,5)) as latitude,
        cast(longitude as decimal (18,5)) as longitude
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct *

    from source

)

select * from renamed