with 
    subcanal as (
    select * 
    from {{ ref('stg_pharma__subcanal') }}
    ), 
    canal as (
        select * 
        from {{ ref('stg_pharma__canal') }}
    ), 
    dimension as (
        select 
        s.subchannel, 
        s.subchannel_id, 
        c.channel
        from subcanal s
        right join canal c
        on s.channel_id = c.channel_id
    )
    select *
    from dimension