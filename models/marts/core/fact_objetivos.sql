with objetivos as (
    select *
    from {{ ref('stg_objectives__objetivos') }}
),

ventas as (
    select  
    mes_id,
    sk_sales_rep,
    SUM(ventas_totales) as ventas_totales, 
    SUM(beneficio_total) as beneficio_total
    from {{ ref('fact_ventas') }}
    group by mes_id, sk_sales_rep
),

dim_rep as (
    select *
    from {{ ref('dim_repventas') }}
    qualify row_number() over (partition by sales_rep_id order by valid_from desc) = 1
),

dim_fecha as (
    select *
    from {{ ref('dim_fecha') }}
),

fact as (
    select
        o.objetivo_id,            
        r.sk_sales_rep,
        f.mes_id,          
        o.sales_rep_id,              
        o.objective_sales, 
        v.ventas_totales, 
        v.beneficio_total,
        case
            when o.objective_sales = 0 or o.objective_sales is null then null
            else round(v.ventas_totales / o.objective_sales * 100, 2)
        end as pct_cumplimiento

    from objetivos o        
    left join dim_rep r
        on o.sales_rep_id = r.sales_rep_id
    left join dim_fecha f
        on o.mes_id = f.mes_id
    left join ventas v
        on o.mes_id = v.mes_id
        and r.sk_sales_rep = v.sk_sales_rep
)

select distinct
* 
from fact
order by objetivo_id