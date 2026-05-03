with 

source as (

    select 
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct (year), 
    cast(md5(trim(cast(year as varchar))) as varchar) as year_id

    from source

)

select * from renamed