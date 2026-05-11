with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(name_sales_rep))) in ('na', '') then 'Unknown'
            else COALESCE(name_sales_rep, 'Unknown')
        end as name_sales_rep,
        sales_team,
        fecha                                    
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as name_sales_rep,
        'Unknown' as sales_team,
        NULL as fecha                            

),

latest as (                                      

    select distinct
        name_sales_rep,
        first_value(sales_team) over (
            partition by name_sales_rep
            order by fecha desc nulls last       
        ) as sales_team
    from source

),

renamed as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep', 'sales_team']) }} as pk_sales_rep,
        name_sales_rep,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep']) }} as sales_rep_id,
        sales_team,
        {{ dbt_utils.generate_surrogate_key(['sales_team']) }} as sales_team_id
    from latest                                  

)

select 
    pk_sales_rep,
    name_sales_rep, 
    sales_rep_id,
    sales_team_id
    
from renamed