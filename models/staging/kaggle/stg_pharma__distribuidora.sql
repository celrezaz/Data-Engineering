with 

source as (

    select
        case
            when lower(trim(TO_VARCHAR(distributor))) in ('NA', 'na', '') then 'Unknown'
            else COALESCE({{ mayusculas_nombres('distributor') }}, 'Unknown')
        end as distributor
    from {{ source('kaggle', 'farmacia') }}

    union all

    select 'Unknown' as distributor

),

renamed as (

    select distinct
        distributor,
        {{ dbt_utils.generate_surrogate_key(['distributor']) }} as distributor_id
    from source

)

select * from renamed