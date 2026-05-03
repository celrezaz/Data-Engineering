with 

source as (

    select
        distributor
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct (distributor), 
    cast(md5(lower(trim(cast(distributor as varchar)))) as varchar) AS distributor_id

    from source

)

select * from renamed