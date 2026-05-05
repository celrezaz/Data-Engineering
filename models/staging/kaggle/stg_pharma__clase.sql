with 

source as (

    select  
        product_class
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct 
    {{ mayusculas_nombres('product_class') }} as product_class, 
    {{ dbt_utils.generate_surrogate_key(['product_class']) }} as product_class_id

    from source

)

select * from renamed