with 

source as (

    select
        distributor
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        distributor

    from source

)

select * from renamed