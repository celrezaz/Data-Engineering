with 

source as (

    select 
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct (year)

    from source

)

select * from renamed