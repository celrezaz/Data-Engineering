with 

source as (

    select 
        
        {{mayusculas_nombres(('name_sales_rep'))}} AS name_sales_rep,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep']) }} AS sales_rep_id,
        sales_team,
        product_name,
        month,
        year,
        TRY_TO_DECIMAL(REPLACE(TRIM(objective), ',', '.'), 10, 3) as objective_sales
    
    from {{ source('kaggle', 'objectives') }}

),

renamed as (

    select
        name_sales_rep,
        sales_rep_id,
        sales_team,
        product_name,
        month,
        year,
        objective_sales

    from source

)

select * from renamed