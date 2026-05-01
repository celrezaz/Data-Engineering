with 

source as (

    select 
        channel
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        channel

    from source

)

select * from renamed