with 

source as (

    select
        case
            when lower(trim(TO_VARCHAR(month))) in ('NA', 'na', '') then 'January'
            else COALESCE({{ mayusculas_nombres('month') }}, 'January')
        end as month,
        case
            when lower(trim(TO_VARCHAR(month))) in ('na', '') then 1
            else COALESCE({{ numero_mes('month') }}, 1)
        end as month_number,
        case
            when lower(trim(TO_VARCHAR(year))) in ('NA', 'na', '') then 1900
            else COALESCE(year, 1900)
        end as year
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'January' as month,
        1         as month_number,
        1900      as year

),

renamed as (

    select
        year,
        month,
        month_number,
        {{ mes_code('year', 'month_number') }} as mes_id
    from source

)

select distinct
    mes_id,
    month,
    year
from renamed