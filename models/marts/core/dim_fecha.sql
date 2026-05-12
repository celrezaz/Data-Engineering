with fecha_dim as (

    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2017-01-01' as date)",
        end_date   = "cast('2026-12-31' as date)"
    ) }}

),

final_dim as (

    select
        date_day                                    as fecha,
        month(date_day)                             as month_number,
        year(date_day)                              as year,
        concat('T', quarter(date_day))              as trimestre,
        case
            when month(date_day) = 1  then 'January'
            when month(date_day) = 2  then 'February'
            when month(date_day) = 3  then 'March'
            when month(date_day) = 4  then 'April'
            when month(date_day) = 5  then 'May'
            when month(date_day) = 6  then 'June'
            when month(date_day) = 7  then 'July'
            when month(date_day) = 8  then 'August'
            when month(date_day) = 9  then 'September'
            when month(date_day) = 10 then 'October'
            when month(date_day) = 11 then 'November'
            when month(date_day) = 12 then 'December'
        end                                         as month,
        case
            when month(date_day) in (12, 1, 2)  then 'Invierno'
            when month(date_day) in (3, 4, 5)   then 'Primavera'
            when month(date_day) in (6, 7, 8)   then 'Verano'
            when month(date_day) in (9, 10, 11) then 'Otoño'
        end                                         as estacion

    from fecha_dim

)

select
    fecha,
    {{ mes_code('year', 'month_number') }}  as mes_id,
    month,
    year,
    trimestre,
    estacion
from final_dim