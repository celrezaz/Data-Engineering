with 

source as (

    select  
        product_class
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct (product_class), 
    cast(md5(lower(trim(cast(product_class as varchar)))) as varchar) AS product_class_id

    from source

)

select * from renamed