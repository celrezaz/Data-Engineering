with 

source as (

    select 
        month,
        year,
        fecha
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        fecha,
        month,
        cast(md5(lower(trim(month)) || cast(year as varchar)) as varchar) as month_id

    from source

)

select 
    fecha,
    month_id
 from renamed