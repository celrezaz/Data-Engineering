with 

source as (

    select 
        channel,
        subchannel
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        channel,
        subchannel,
        cast(md5(lower(trim(subchannel)) || cast(channel as varchar)) as varchar) as subchannel_id,
        cast(md5(lower(trim(cast(channel as varchar)))) as varchar) as channel_id


    from source

)

select 
    subchannel,
    subchannel_id, 
    channel_id
from renamed