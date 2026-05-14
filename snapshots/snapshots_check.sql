{% snapshot sales_rep_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='sales_rep_id',
        strategy='check',
        check_cols='all'
    )
}}

select * from {{ ref('stg_pharma__repventas') }}

{% endsnapshot %}