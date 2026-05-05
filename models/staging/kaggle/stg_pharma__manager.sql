with 

source as (

    select 
        manager
    from {{ source('kaggle', 'farmacia') }}

),

renamed as (

    select distinct
        manager,
        {{ dbt_utils.generate_surrogate_key(['manager']) }} AS manager_id
    from source

)

select *
from renamed