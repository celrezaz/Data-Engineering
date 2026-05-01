with 

source as (

    select 
        year
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        year

    from source

)

select * from renamed