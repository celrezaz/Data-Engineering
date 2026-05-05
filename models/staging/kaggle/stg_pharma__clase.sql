with 

source as (

    select  
        product_class
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct 
    {{ mayusculas_nombres('product_class') }} as product_class, 
    {{ crear_id(['product_class']) }} as product_class_id

    from source

)

select * from renamed