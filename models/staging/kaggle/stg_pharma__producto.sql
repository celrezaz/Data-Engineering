with 

source as (

    select  
        product_name,
        product_class,
        quantity,
        precio_coste,
        precio_venta
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select

        cast(md5(lower(trim(cast(product_name as varchar)))) as varchar) AS product_id,
        cast((trim(cast(product_name as varchar))) as varchar) AS product_name,
        cast(md5(lower(trim(cast(product_class as varchar)))) as varchar) AS product_class_id,
        cast(quantity as decimal (10,3)) AS quantity,
        cast(precio_coste as decimal (10,3)) AS precio_coste,
        cast(precio_venta as decimal (10,3)) AS precio_venta

    from source

)

select * from renamed