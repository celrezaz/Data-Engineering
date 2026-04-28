{{ config(materialized='view') }}

with 

source as (

    select * from {{ source('postgres_db', 'addresses') }}

),

renamed as (

    select *

    from source

)

select * from renamed