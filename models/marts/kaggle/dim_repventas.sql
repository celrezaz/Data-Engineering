with rep_ventas as (
    select 
        pk_sales_rep,
        sales_rep_id,
        sales_team_id,
        name_sales_rep,
        dbt_valid_from,
        dbt_valid_to,
        dbt_valid_to is null as is_current
    from {{ ref('sales_rep_snapshot') }}  
    ), 
    equipo_ventas as (
        select * 
        from {{ ref('stg_pharma__equipoventas') }}
    ), 
    manager as (
        select * 
        from {{ ref('stg_pharma__manager') }}
    ), 
    union_dim as (
        select 
            r.pk_sales_rep,
            r.sales_rep_id, 
            s.sales_team_id, 
            r.name_sales_rep,
            s.manager_id, 
            s.sales_team,
            r.dbt_valid_from,
            r.dbt_valid_to,
            r.is_current
        from rep_ventas r
        right join equipo_ventas s
            on r.sales_team_id = s.sales_team_id
    ), 
    union2_dim as (
        select
            u.pk_sales_rep,
            u.sales_rep_id,
            u.sales_team, 
            u.sales_team_id, 
            u.name_sales_rep,
            m.manager_id, 
            m.manager,
            u.dbt_valid_from,
            u.dbt_valid_to,
            u.is_current
        from union_dim u 
        right join manager m 
            on u.manager_id = m.manager_id
    ) 

select
    pk_sales_rep,
    sales_rep_id, 
    name_sales_rep, 
    sales_team, 
    manager,
    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to,
    is_current
from union2_dim
order by name_sales_rep, valid_from