{% snapshot snapshots_check %}

{{
    config(
        target_schema='snapshots',
        unique_key='sales_rep_id',
        strategy='check',
        check_cols=['sales_team_id']
    )
}}

select * from {{ ref('stg_pharma__repventas') }}

{% endsnapshot %}