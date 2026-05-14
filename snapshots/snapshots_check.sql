{% snapshot sales_rep_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='sk_sales_rep',
        strategy='check',
        check_cols=['sales_team_id']
    )
}}

select * from {{ ref('stg_pharma__repventas') }}

{% endsnapshot %}