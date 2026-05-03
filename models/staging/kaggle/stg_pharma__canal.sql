with 

source as (

    select 
        channel
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct (channel), 
    cast(md5(lower(trim(cast(channel as varchar)))) as varchar) as channel_id

    from source

)

select * from renamed