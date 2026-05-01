with 

source as (

    select  
        product_name,
        product_class,
        precio_coste,
        precio_venta
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        product_name,
        product_class,
        precio_coste,
        precio_venta

    from source

)

select * from renamed