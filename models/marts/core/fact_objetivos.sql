with objetivos as (
    select *
    from {{ ref('stg_objectives__objetivos') }}
    where sales_rep_id != '88183b946cc5f0e8c96b2e66e1c74a7e'
),

ventas as (
    select  
        mes_id,
        sk_sales_rep,
        sum(ventas_totales)   as ventas_totales, 
        sum(beneficio_total)  as beneficio_total
    from {{ ref('fact_ventas') }}
    group by mes_id, sk_sales_rep
),

dim_rep as (
    select *
    from {{ ref('dim_repventas') }}
    qualify row_number() over (partition by sales_rep_id order by valid_from asc) = 1
),

fact as (
    select
        o.objetivo_id,            
        r.sk_sales_rep,
        o.mes_id,          
        o.sales_rep_id,              
        o.objective_sales, 
        v.ventas_totales, 
        v.beneficio_total,
        case
            when o.objective_sales = 0 or o.objective_sales is null then null
            else round(v.ventas_totales / o.objective_sales * 100, 2)
        end as pct_cumplimiento

    from objetivos o        
    inner join dim_rep r          
        on o.sales_rep_id = r.sales_rep_id
    left join ventas v
        on o.mes_id = v.mes_id
        and r.sk_sales_rep = v.sk_sales_rep
)

select *
from fact
order by objetivo_id, pct_cumplimiento desc