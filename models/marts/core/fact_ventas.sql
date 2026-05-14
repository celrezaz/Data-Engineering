with ventas as (
    select
        linea_venta_id,
        venta_id,
        distributor_id,
        product_id,
        subchannel_id,
        customer_id,
        fecha,
        sales_rep_id,
        quantity
    from {{ ref('stg_pharma__ventas') }}
),

dim_producto as (
    select
        sk_product,
        product_id,
        product_name,
        product_class,
        precio_coste,
        precio_venta,
        valid_from,
        valid_to,
        is_current
    from {{ ref('dim_producto') }}
),

dim_rep as (
    select
        sk_sales_rep,
        sales_rep_id,
        name_sales_rep,
        sales_team,
        manager,
        valid_from,
        valid_to,
        is_current
    from {{ ref('dim_repventas') }}
),

dim_cliente as (
    select
        customer_id,
        customer_name,
        country,
        city,
        latitude,
        longitude
    from {{ ref('dim_cliente') }}
),

dim_subcanal as (
    select
        subchannel_id,
        subchannel,
        channel
    from {{ ref('dim_subcanal') }}
),

dim_distribuidora as (
    select
        distributor_id,
        distributor
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
        p.sk_product,
        r.sk_sales_rep,
        c.customer_id,
        s.subchannel_id,
        d.distributor_id,
        f.fecha,
        v.quantity,
        p.precio_venta * v.quantity                    as ventas_totales,
        (p.precio_venta - p.precio_coste) * v.quantity as beneficio_total

    from ventas v
    left join dim_producto p
        on v.product_id = p.product_id
        and v.fecha >= p.valid_from
        and (p.valid_to is null or v.fecha <= p.valid_to)
    
    left join dim_rep r
        on  v.sales_rep_id = r.sales_rep_id
        and (
            (r.valid_to is null and r.is_current = true)
            or
            (r.valid_to is not null
                and v.fecha >= r.valid_from
                and v.fecha <  r.valid_to)
        )

    left join dim_cliente c
        on v.customer_id   = c.customer_id

    left join dim_subcanal s
        on v.subchannel_id = s.subchannel_id

    left join dim_distribuidora d
        on v.distributor_id = d.distributor_id

    left join dim_fecha f
        on v.fecha = f.fecha
)

select * from fact
