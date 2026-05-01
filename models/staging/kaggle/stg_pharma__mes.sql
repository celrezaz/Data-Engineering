with 

source as (

    select 
        month
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        month

    from source

)

select * from renamed