with 

source as (

    select 
        distributor,
        customer_name,
        subchannel,
        product_name,
        name_sales_rep,
        fecha,
        month,
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        cast(md5(
            lower(trim(cast(fecha as varchar))) ||
            lower(trim(cast(name_sales_rep as varchar))) ||
            lower(trim(cast(customer_name as varchar))) ||
            lower(trim(cast(product_name as varchar)))) as varchar) as id_linea_venta,
        cast(md5(
            lower(trim(cast(fecha as varchar))) ||
            lower(trim(cast(name_sales_rep as varchar))) ||
            lower(trim(cast(customer_name as varchar)))) as varchar) as id_venta,
        cast(md5(lower(trim(month)) || cast(year as varchar)) as varchar) as month_id,
        cast(md5(lower(trim(cast(product_name as varchar)))) as varchar) as product_id,
        cast(md5(lower(trim(cast(name_sales_rep as varchar)))) as varchar) as sales_rep_id,
        cast(md5(lower(trim(cast(customer_name as varchar)))) as varchar) as customer_id,
        fecha,
        cast(md5(lower(trim(cast(distributor as varchar)))) as varchar) as distributor_id,
        cast(md5(lower(trim(cast(subchannel as varchar)))) as varchar) as subchannel_id

    from source

)

select * from renamed