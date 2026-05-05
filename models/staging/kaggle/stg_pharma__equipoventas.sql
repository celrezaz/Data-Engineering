with 

source as (

    select 
        manager,
        sales_team
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['manager']) }} as manager_id, 
        sales_team,
        {{ dbt_utils.generate_surrogate_key(['sales_team']) }} as sales_team_id

    from source

)

select 
    sales_team,
    sales_team_id,
    manager_id
from renamed