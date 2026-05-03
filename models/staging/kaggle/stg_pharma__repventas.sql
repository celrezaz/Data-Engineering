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
        sales_team,
        cast(md5(lower(trim(cast(name_sales_rep as varchar)))) as varchar) AS sales_rep_id,
        cast(md5(lower(trim(cast(sales_team as varchar)))) as varchar) AS sales_team_id


    from source

)

select 
    sales_rep_id,
    sales_team_id, 
    name_sales_rep
 from renamed