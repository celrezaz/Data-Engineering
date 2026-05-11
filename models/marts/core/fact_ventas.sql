with ventas as (
    select *
    from {{ ref('stg_pharma__ventas') }}
),

dim_producto as (
    select *
    from {{ ref('dim_producto') }}
),

dim_rep as (
    select *
    from {{ ref('dim_repventas') }}
),

dim_cliente as (
    select *
    from {{ ref('dim_cliente') }}
),

dim_subcanal as (
    select *
    from {{ ref('dim_subcanal') }}
),

dim_distribuidora as (
    select *
    from {{ ref('dim_distribuidora') }}
),

dim_fecha as (
    select *
    from {{ ref('dim_fecha') }}
),

fact as (
    select
        v.linea_venta_id,
        v.venta_id,
        p.pk_producto,
        r.pk_sales_rep,
        c.id_cliente,
        s.id_subcanal,
        d.id_distribuidora,
        f.fecha,
        v.product_id,
        v.customer_id,
        v.sales_rep_id,
        v.quantity,
        p.precio_venta * v.quantity as ventas_totales,
        (p.precio_venta - p.precio_coste) * v.quantity as beneficio_total

    from ventas v
    left join dim_producto p
        on v.product_id = p.id_producto
       and v.fecha between p.valid_from and coalesce(p.valid_to, '9999-12-31')
    left join dim_repventas r
        on v.sales_rep_id = r.id_representante_ventas
       and v.fecha between r.valid_from and coalesce(r.valid_to, '9999-12-31')
    left join dim_cliente c
        on v.customer_id = c.id_cliente
    left join dim_subcanal s
        on v.subchannel_id = s.id_subcanal
    left join dim_distribuidora d
        on v.distributor_id = d.id_distribuidora
    left join dim_fecha f
        on v.fecha = f.fecha
)

select *
from fact
