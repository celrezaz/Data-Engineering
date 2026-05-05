with 

source as (

    select 
        
        {{mayusculas_nombres(('name_sales_rep'))}} AS name_sales_rep,
        {{ crear_id(['name_sales_rep']) }} AS sales_rep_id,
        sales_team,
        product_name,
        month,
        year,
        objective
    
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
        objective

    from source

)

select * from renamed