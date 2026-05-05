with 

source as (

    select 
        {{ mayusculas_nombres('month') }} as month,
        {{ numero_mes('month') }} as month_number,
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        year,
        month,
        month_number, 
        {{ mes_code ('year', 'month_number') }} as mes_id

    from source

)

select distinct
    mes_id,
    month, 
    year
    
from renamed