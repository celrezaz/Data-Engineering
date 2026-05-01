with 

source as (

    select * from {{ source('kaggle', 'objectives') }}

),

renamed as (

    select
        name_sales_rep,
        sales_team,
        product_name,
        month,
        year,
        objective

    from source

)

select * from renamed