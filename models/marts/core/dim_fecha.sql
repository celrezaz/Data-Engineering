with fecha_dim as (

    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2017-01-01' as date)",
        end_date = "cast('2026-12-31' as date)"
    ) }}

),

final_dim as (

    select
          date_day as fecha, 
          month(date_day) as month, 
          year(date_day) as year, 
          concat('T', quarter(date_day)) as trimestre,
          case
              when month(date_day) in (12, 1, 2) then 'Invierno'
              when month(date_day) in (3, 4, 5) then 'Primavera'
              when month(date_day) in (6, 7, 8) then 'Verano'
              when month(date_day) in (9, 10, 11) then 'Otoño'
          end as estacion

    from fecha_dim

)

select 
    fecha, 
    {{ mes_code ('year', 'month') }} as mes_id, 
    year, 
    trimestre, 
    estacion
from final_dim