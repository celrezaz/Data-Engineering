with 

source as (

    select 
        manager
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        manager,
        cast(md5(lower(trim(cast(manager as varchar)))) as varchar) AS manager_id
    from source

)

select *
from renamed