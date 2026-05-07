with ventas as (

    select 
    LINEA_VENTA_ID,
    VENTA_ID,
    DISTRIBUTOR_ID,
    PRODUCT_ID,
    SUBCHANNEL_ID,
    CUSTOMER_ID,
    FECHA,
    SALES_REP_ID,
    QUANTITY
    from {{ ref('stg_pharma__ventas') }}

),

final as (

    select
        LINEA_VENTA_ID,
        VENTA_ID,
        DISTRIBUTOR_ID,
        PRODUCT_ID,
        SUBCHANNEL_ID,
        CUSTOMER_ID,
        FECHA,
        SALES_REP_ID,
        QUANTITY
    from ventas

)

select * from final