{{ config(
    materialized='incremental',
    unique_key='product_id',
    incremental_strategy='delete+insert'
    ) 
    }}

with 

source as (

    select * from {{ source('google_sheet', 'budget') }}

),

renamed as (

    select *

    from source

)

select * from renamed

{% if is_incremental() %}

  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}