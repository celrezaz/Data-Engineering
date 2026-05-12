with producto as (
    select * 
    from {{ ref('stg_pharma__producto') }}), 
clase as (
    select * 
    from {{ ref('stg_pharma__clase') }}), 
union_dim as (
    select
        p.is_current,
        p.pk_product, 
        p.product_name, 
        p.product_id,
        c.product_class_id,
        c.product_class, 
        p.precio_coste, 
        p.precio_venta, 
        p.valid_from, 
        p.valid_to
    from producto p
    left join clase c
        on p.product_class_id = c.product_class_id

)

select 
    pk_product, 
    product_name, 
    product_id, 
    product_class, 
    precio_coste, 
    precio_venta, 
    valid_from, 
    valid_to, 
    is_current
from union_dim