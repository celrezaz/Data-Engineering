with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(manager))) in ('na', '') then 'Unknown'
            else COALESCE(manager, 'Unknown')
        end as manager,
        case
            when id_venta = 'V23419' then 'Bravo'           
            when lower(trim(TO_VARCHAR(sales_team))) in ('na', '') then 'Unknown'
            else COALESCE(sales_team, 'Unknown')
        end as sales_team
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as manager,
        'Unknown' as sales_team

),

renamed as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['manager']) }} as manager_id, 
        sales_team,
        {{ dbt_utils.generate_surrogate_key(['sales_team']) }} as sales_team_id, 
        manager
    from source

)

select 
    sales_team,
    sales_team_id,
    manager_id, 
    manager
from renamed