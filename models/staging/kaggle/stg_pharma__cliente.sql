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
        {{ crear_id(['customer_name']) }} as customer_id, 
        {{ crear_id(['city']) }} as city_id
    from source

)

select * from renamed