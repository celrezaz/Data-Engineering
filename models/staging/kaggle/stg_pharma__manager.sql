with 

source as (

    select 
        manager
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        manager,
        {{ crear_id(['manager']) }} AS manager_id
    from source

)

select *
from renamed