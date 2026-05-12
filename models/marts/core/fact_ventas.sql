{{ config(
    materialized='incremental',
    unique_key='fecha',
    incremental_strategy='delete+insert'
) }}

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

    {% if is_incremental() %}
        where fecha >= DATEADD(day, -5, CURRENT_DATE())
    {% endif %}
),

dim_producto as (
    select
        pk_product,
        product_id,
        precio_coste,
        precio_venta,
        valid_from,
        valid_to
    from {{ ref('dim_producto') }}
),

dim_rep as (
    select
        pk_sales_rep,
        sales_rep_id,
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
    select * from {{ ref('dim_fecha') }}
),

fact as (
    select
        v.linea_venta_id,
        v.venta_id,
        p.pk_product,
        r.pk_sales_rep,
        c.customer_id,
        s.subchannel_id,
        d.distributor_id,
        f.fecha,
        v.product_id,
        v.sales_rep_id,
        v.quantity,
        p.precio_venta * v.quantity                    as ventas_totales,
        (p.precio_venta - p.precio_coste) * v.quantity as beneficio_total

    from ventas v
    left join dim_producto p
        on  v.product_id = p.product_id
        and v.fecha >= p.valid_from
        and (v.fecha < p.valid_to or p.valid_to is null)
    left join dim_rep r
        on  v.sales_rep_id = r.sales_rep_id
        and r.is_current = true
    left join dim_cliente c
        on v.customer_id = c.customer_id
    left join dim_subcanal s
        on v.subchannel_id = s.subchannel_id
    left join dim_distribuidora d
        on v.distributor_id = d.distributor_id
    left join dim_fecha f
        on v.fecha = f.fecha
)

select * from fact