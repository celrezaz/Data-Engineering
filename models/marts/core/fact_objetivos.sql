with objetivos as (
    select *
    from {{ ref('stg_objectives__objetivos') }}
),

dim_rep as (
    select *
    from {{ ref('dim_repventas') }}
),

dim_fecha as (
    select *
    from {{ ref('dim_fecha') }}
),

fact as (
    select
        o.objetivo_id,            
        r.pk_sales_rep,
        f.mes_id,          
        o.sales_rep_id,              
        o.objective_sales

    from objetivos o        
    left join dim_rep r
        on  o.sales_rep_id = r.sales_rep_id
    left join dim_fecha f
        on o.mes_id = f.mes_id
)

select distinct * from fact