with 

source as (

    select 
        name_sales_rep,
        sales_team
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        name_sales_rep,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep']) }} AS sales_rep_id,
        sales_team,
        {{ dbt_utils.generate_surrogate_key(['sales_team']) }} AS sales_team_id


    from source

)

select 
    sales_rep_id,
    sales_team_id, 
    name_sales_rep
 from renamed