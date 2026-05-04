with 

source as (

    select 
        TRIM(channel) as channel, 
        {{ crear_id(['channel']) }} as channel_id
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct 
    channel, 
    channel_id

    from source

)

select * from renamed