with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(name_sales_rep))) in ('na', '') then 'Unknown'
            else COALESCE(name_sales_rep, 'Unknown')
        end as name_sales_rep,
        sales_team
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as name_sales_rep,
        'Unknown' as sales_team

),

renamed as (

    select distinct
        name_sales_rep,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep']) }} as sales_rep_id,
        sales_team,
        {{ dbt_utils.generate_surrogate_key(['sales_team']) }} as sales_team_id
    from source

)

select 
    name_sales_rep, 
    sales_rep_id,
    sales_team_id
    
from renamed