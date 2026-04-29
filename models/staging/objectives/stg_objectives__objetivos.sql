with 

source as (

    select * from {{ source('objectives', 'objetivos') }}

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