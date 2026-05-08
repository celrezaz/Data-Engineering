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
    FROM cliente cl
    RIGHT JOIN ciudad c
    ON cl.city_id = c.city_id), 
final_union as (
    select
    d.customer_id, 
    d.customer_name, 
    d.city, 
    d.city_id,
    d.country_id, 
    d.latitude, 
    d.longitude, 
    p.country, 
    p.country_id
    FROM final_union d
    RIGHT JOIN pais p 
    ON  d.country_id = p.country_id
) 
select * from final_union