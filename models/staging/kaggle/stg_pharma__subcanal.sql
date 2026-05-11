with 

source as (

    select
        case
            when lower(trim(TO_VARCHAR(channel))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE({{ mayusculas_nombres('channel') }}, 'Unknown')
        end as channel,
        case
            when lower(trim(TO_VARCHAR(subchannel))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE({{ mayusculas_nombres('subchannel') }}, 'Unknown')
        end as subchannel
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as channel,
        'Unknown' as subchannel

),

renamed as (

    select distinct
        channel,
        {{ dbt_utils.generate_surrogate_key(['channel']) }}     as channel_id,
        subchannel,
        {{ dbt_utils.generate_surrogate_key(['subchannel']) }}  as subchannel_id
    from source

)

select
    subchannel,
    subchannel_id,
    channel_id
from renamed