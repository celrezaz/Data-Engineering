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
        cast((trim(cast(product_name as varchar))) as varchar) AS product_name,
        {{ dbt_utils.generate_surrogate_key(['product_name']) }} AS product_id,
        {{ dbt_utils.generate_surrogate_key(['product_class']) }} AS product_class_id,
        cast(quantity as decimal (10,3)) AS quantity,
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_coste), ',', '.'), 10, 3) as precio_coste, 
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_venta), ',', '.'), 10, 3) as precio_venta

    from source

)

select distinct * from renamed