with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(manager))) in ('na', '') then 'Unknown'
            else COALESCE(manager, 'Unknown')
        end as manager
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as manager

),

renamed as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['manager']) }} as manager_id, 
        manager
    from source

)

select 
    manager_id,
    manager
from renamed