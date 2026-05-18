with

seed as (
    select
        sales_team,
        manager
    from {{ ref('canonical_managers') }}
),

source as (
    select
        case
            when lower(trim(TO_VARCHAR(manager))) in ('na', '') then 'Unknown'
            else COALESCE(trim(TO_VARCHAR(manager)), 'Unknown')
        end as manager,
        case
            when id_venta = 'V23419' then 'Bravo'
            when lower(trim(TO_VARCHAR(sales_team))) in ('na', '') then 'Unknown'
            else COALESCE(trim(TO_VARCHAR(sales_team)), 'Unknown')
        end as sales_team
    from {{ source('kaggle', 'farmacia') }}

    union all

    select
        'Unknown' as manager,
        'Unknown' as sales_team
),

enriched as (
    select distinct
        COALESCE(seed.manager, s.manager) as manager
    from source s
    left join seed
        on lower(trim(s.sales_team)) = lower(trim(seed.sales_team))
),

cleaned as (
    select
        case
            when lower(trim(manager)) in ('na', '') then 'Unknown'
            else COALESCE(manager, 'Unknown')
        end as manager
    from enriched
),

renamed as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['manager']) }} as manager_id,
        manager
    from cleaned
)

select
    manager_id,
    manager
from renamed