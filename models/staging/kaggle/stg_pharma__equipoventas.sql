with 

source as (

    select 
        manager,
        sales_team
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        manager,
        sales_team,
        cast(md5(lower(trim(cast(manager as varchar)))) as varchar) AS manager_id,
        cast(md5(lower(trim(cast(sales_team as varchar)))) as varchar) AS sales_team_id

    from source

)

select 
    sales_team_id,
    sales_team,
    manager_id
from renamed