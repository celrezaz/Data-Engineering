{{ config(materialized='view') }}

with 

source as (

    select * from {{ source('google_sheet', 'budget') }}

),

renamed as (

    select *

    from source

)

select * from renamed