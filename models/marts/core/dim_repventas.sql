with rep_ventas as (
    select 
        sk_sales_rep,
        sales_rep_id,
        sales_team_id,
        name_sales_rep,
        dbt_valid_from,
        dbt_valid_to,
        dbt_valid_to is null as is_current
    from {{ ref('sales_rep_snapshot') }}  
), 

equipo_ventas as (
    select 
        sales_team_id,
        sales_team,
        manager_id
    from {{ ref('stg_pharma__equipoventas') }}
), 

manager as (
    select 
        manager_id,
        manager
    from {{ ref('stg_pharma__manager') }}
),

dim as (
    select
        r.sk_sales_rep,
        r.sales_rep_id,
        r.name_sales_rep,
        e.sales_team,
        m.manager,
        case 
            when row_number() over (partition by r.sales_rep_id order by r.dbt_valid_from asc) = 1
            then cast('2000-01-01' as date)
            else cast(r.dbt_valid_from as date)
        end as valid_from,
        case
            when r.dbt_valid_to is null then null
            else cast(r.dbt_valid_to as date) - interval '1 day'
        end as valid_to,
        r.is_current
    from rep_ventas r
    left join equipo_ventas e 
        on r.sales_team_id = e.sales_team_id
    left join manager m
        on e.manager_id = m.manager_id
)

select distinct *
from dim
