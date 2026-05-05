with 

source as (

    select 
        country
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        country,
        {{ dbt_utils.generate_surrogate_key(['country']) }} AS country_id

    from source

)

select * from renamed