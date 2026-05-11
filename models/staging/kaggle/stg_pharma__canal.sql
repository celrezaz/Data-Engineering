with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(channel))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE({{ mayusculas_nombres('channel') }}, 'Unknown')
        end as channel
    from {{ source('kaggle', 'farmacia') }}

    union all

    select 'Unknown' as channel

),

renamed as (

    select distinct 
        channel,
        {{ dbt_utils.generate_surrogate_key(['channel']) }} as channel_id
    from source

)

select * from renamed