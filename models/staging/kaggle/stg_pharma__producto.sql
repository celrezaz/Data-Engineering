with 

source as (

    select  
        product_name,
        product_class
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        cast((trim(cast(product_name as varchar))) as varchar) AS product_name,
        {{ dbt_utils.generate_surrogate_key(['product_name']) }} AS product_id,
        {{ dbt_utils.generate_surrogate_key(['product_class']) }} AS product_class_id,

    from source

)

select distinct * from renamed