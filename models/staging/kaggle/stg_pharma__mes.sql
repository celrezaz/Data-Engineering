with 

source as (

    select 
        {{ mayusculas_nombres('month') }} as month,
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        year,
        month,
        {{ numero_mes('month') }} as month_number

    from source

)

select distinct
    year,
    month_number
    
from renamed