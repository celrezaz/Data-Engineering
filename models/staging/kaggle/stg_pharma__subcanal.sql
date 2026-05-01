with 

source as (

    select 
        channel,
        sub_channel
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        channel,
        sub_channel

    from source

)

select * from renamed