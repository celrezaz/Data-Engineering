with 

source as (

    select
        {{ mayusculas_nombres('month') }} as month,
        {{ numero_mes('month') }} as month_number, 
        year,
        fecha
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
    fecha, 
    {{ mes_code ('year', 'month_number') }} as mes_id

    from source

)

select distinct *
 from renamed