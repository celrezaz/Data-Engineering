with 

source as (

    select
        distributor
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct 
    {{ mayusculas_nombres('distributor') }} as distributor, 
    {{ dbt_utils.generate_surrogate_key(['distributor']) }} as distributor_id

    from source

)

select * from renamed