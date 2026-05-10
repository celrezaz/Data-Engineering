with 

source as (

    select 
        customer_name,
        city, 
        cast(latitude as decimal (18,5)) as latitude,
        cast(longitude as decimal (18,5)) as longitude
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        customer_name,
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }} as customer_id, 
        {{ dbt_utils.generate_surrogate_key(['city']) }} as city_id, 
        latitude, 
        longitude
    from source

)

select * from renamed