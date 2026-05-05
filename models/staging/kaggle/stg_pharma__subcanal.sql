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
        {{ dbt_utils.generate_surrogate_key(['channel']) }} AS channel_id,
        subchannel,
        {{ dbt_utils.generate_surrogate_key(['subchannel']) }} AS subchannel_id


    from source

)

select 
    subchannel,
    subchannel_id, 
    channel_id
from renamed