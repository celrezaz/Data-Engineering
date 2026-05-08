with rep_ventas as (
    select *
    from {{ ref('stg_pharma__repventas') }}
    ), 
    equipo_ventas as (
        select * 
        from {{ ref('stg_pharma__equipoventas') }}
    ), manager as (
        select * 
        from {{ ref('stg_pharma__manager') }}
    ), 
    union_dim as (
        select 
        r.sales_rep_id, 
        s.sales_team_id, 
        r.name_sales_rep,
        s.manager_id, 
        s.sales_team
        from rep_ventas r
        right join equipo_ventas s
        on r.sales_team_id = s.sales_team_id), 
    unio2_dim as (
        select
            u.sales_rep_id,
            u.sales_team, 
            u.sales_team_id, 
            u.name_sales_rep,
            m.manager_id, 
            m.manager 
        from union_dim u 
        right join manager m 
        on u.manager_id = m.manager_id) 
        select
        sales_rep_id, 
        name_sales_rep, 
        sales_team, 
        manager
        from unio2_dim

