with 

source as (

    select 
        month,
        fecha
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        month,
        fecha

    from source

)

select * from renamed