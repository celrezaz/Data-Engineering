with 

source as (

    select 
        distributor,
        customer_name,
        subchannel,
        product_name,
        name_sales_rep,
        fecha, 
        quantity,        
        precio_venta,    
        precio_coste 
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['fecha', 'name_sales_rep', 'customer_name', 'product_name']) }} AS linea_venta_id,
        {{ dbt_utils.generate_surrogate_key(['fecha', 'name_sales_rep', 'customer_name']) }} AS venta_id,
        {{ dbt_utils.generate_surrogate_key(['distributor']) }} AS distributor_id,
        {{ dbt_utils.generate_surrogate_key(['product_name']) }} AS product_id,
        {{ dbt_utils.generate_surrogate_key(['subchannel']) }} AS subchannel_id,
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }} AS customer_id,
        fecha, 
         {{ dbt_utils.generate_surrogate_key(['name_sales_rep']) }} AS sales_rep_id,
        cast(quantity as decimal (10,3)) AS quantity,
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_coste), ',', '.'), 10, 3) as precio_coste, 
        TRY_TO_DECIMAL(REPLACE(TRIM(precio_venta), ',', '.'), 10, 3) as precio_venta
    from source

)

select * from renamed