with 

source as (

    select 
        {{ mayusculas_nombres('channel') }} as channel, 
        {{ dbt_utils.generate_surrogate_key(['channel']) }} as channel_id
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct 
    channel, 
    channel_id

    from source

)

select * from renamed