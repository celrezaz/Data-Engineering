with 

source as (

    select 
        month,
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        month,
        year,
        cast(md5(lower(trim(month)) || cast(year as varchar)) as varchar) as month_id,
        cast(md5(trim(cast(year as varchar))) as varchar) as year_id

    from source

)

select * from renamed