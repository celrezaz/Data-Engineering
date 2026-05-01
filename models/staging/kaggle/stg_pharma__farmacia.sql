with 

source as (

    select * from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        distributor,
        customer_name,
        city,
        country,
        latitude,
        longitude,
        channel,
        sub_channel,
        product_name,
        product_class,
        quantity,
        month,
        year,
        name_sales_rep,
        manager,
        sales_team,
        fecha,
        id_venta,
        precio_coste,
        precio_venta,
        sales

    from source

)

select * from renamed