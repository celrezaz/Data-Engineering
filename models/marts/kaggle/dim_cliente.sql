with cliente as (
    select * 
    from {{ ref('stg_pharma__cliente') }}
), 

pais as (
    select * 
    from {{ ref('stg_pharma__pais') }}
), 

ciudad as (
    select * 
    from {{ ref('stg_pharma__ciudad') }}
), 

union_dim as (
    select 
        cl.customer_id,
        cl.customer_name, 
        c.city,
        c.city_id,
        c.country_id, 
        c.latitude, 
        c.longitude
    from cliente cl
    right join ciudad c
        on cl.city_id = c.city_id
), 

final as (
    select
        d.customer_id, 
        d.customer_name, 
        d.country_id,
        d.city, 
        d.city_id, 
        d.latitude, 
        d.longitude, 
        p.country
    from union_dim d
    right join pais p 
        on d.country_id = p.country_id
) 

select 
    customer_id, 
    customer_name, 
    country, 
    city, 
    latitude, 
    longitude
from final