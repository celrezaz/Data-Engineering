{{ config(materialized='view') }}

with 

source as (

    select * from {{ source('postgres_db', 'promos') }}

),

renamed as (

    select
        promo_id,
        discount,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed