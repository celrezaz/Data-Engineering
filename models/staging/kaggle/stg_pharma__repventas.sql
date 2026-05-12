with 

source as (

    select 
        case
            when lower(trim(TO_VARCHAR(name_sales_rep))) in ('na', '') then 'Unknown'
            else COALESCE(name_sales_rep, 'Unknown')
        end as name_sales_rep,
        case
            when id_venta = 'V23419' then 'Bravo'
            when lower(trim(TO_VARCHAR(sales_team))) in ('na', '') then 'Unknown'
            else COALESCE(sales_team, 'Unknown')
        end as sales_team,
        fecha                                    
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as name_sales_rep,
        'Unknown' as sales_team,
        NULL as fecha                            

),

renamed as (

    select distinct
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep', 'sales_team']) }} as pk_sales_rep,
        name_sales_rep,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep']) }} as sales_rep_id,
        sales_team,
        {{ dbt_utils.generate_surrogate_key(['sales_team']) }} as sales_team_id
    from source                                  

)

select distinct
    pk_sales_rep,
    name_sales_rep, 
    sales_rep_id,
    sales_team_id
    
from renamed