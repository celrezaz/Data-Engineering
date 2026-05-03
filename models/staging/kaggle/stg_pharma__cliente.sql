with 

source as (

    select 
        customer_name,
        city
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        customer_name,
        cast(md5(lower(trim(cast(customer_name as varchar)))) as varchar) AS customer_id,
        cast(md5(lower(trim(cast(city as varchar)))) as varchar) AS city_id
    from source

)

select * from renamed