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
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }} as customer_id, 
        {{ dbt_utils.generate_surrogate_key(['city']) }} as city_id
    from source

)

select * from renamed