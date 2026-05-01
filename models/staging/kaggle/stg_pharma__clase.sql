with 

source as (

    select  
        product_class
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select
        product_class

    from source

)

select * from renamed