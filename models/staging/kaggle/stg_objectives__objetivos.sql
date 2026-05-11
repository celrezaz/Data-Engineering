with 

canonical as (
    select name from {{ ref('canonical_sales_reps') }}
),

source as (

    select
        o.name_sales_rep,
        case
            when lower(trim(TO_VARCHAR(o.name_sales_rep))) in ('NA', 'na', '') then 'Unknown'
            when o.name_sales_rep is null                                 then 'Unknown'
            else c.name
        end as name_sales_rep_clean,
        case
            when trim(lower(regexp_replace(TO_VARCHAR(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('alfa', 'al fa', 'alpha')
                then 'Alfa'
            when trim(lower(regexp_replace(TO_VARCHAR(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('bravo', 'brav0')
                then 'Bravo'
            when trim(lower(regexp_replace(TO_VARCHAR(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('charlie', 'charli')
                then 'Charlie'
            when trim(lower(regexp_replace(TO_VARCHAR(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('delta', 'delt a')
                then 'Delta'
            when lower(trim(TO_VARCHAR(o.sales_team))) in ('NA', 'na', '')      then 'Unknown'
            when o.sales_team is null                                      then 'Unknown'
            else TO_VARCHAR(o.sales_team)
        end as sales_team,
        o.month,
        {{ numero_mes('o.month') }} as month_number,
        o.year,
        TRY_TO_DECIMAL(REPLACE(TRIM(o.objective), ',', '.'), 10, 3) as objective_sales

    from {{ source('kaggle', 'objectives') }} o
    left join canonical c on true
    qualify row_number() over (
        partition by o.name_sales_rep, o.sales_team, o.month, o.year
        order by case
            when lower(trim(TO_VARCHAR(o.name_sales_rep))) in ('NA', 'na', '') or o.name_sales_rep is null
                then 0
            else JAROWINKLER_SIMILARITY(
                lower(trim(REGEXP_REPLACE(TO_VARCHAR(o.name_sales_rep), '[^a-zA-Z0-9 ]', ''))),
                lower(c.name)
            )
        end desc
    ) = 1
    and (
        lower(trim(TO_VARCHAR(o.name_sales_rep))) in ('NA', 'na', '')
        or o.name_sales_rep is null
        or JAROWINKLER_SIMILARITY(
            lower(trim(REGEXP_REPLACE(TO_VARCHAR(o.name_sales_rep), '[^a-zA-Z0-9 ]', ''))),
            lower(c.name)
        ) > 0.85
    )

),

deduped as (

    select *
    from source
    qualify row_number() over (
        partition by {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean', 'year', 'month_number']) }}
        order by 1
    ) = 1

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean', 'year', 'month_number']) }} AS objetivo_id,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean']) }} as sales_rep_id,
        {{ mes_code('year', 'month_number') }} as mes_id,
        objective_sales

    from deduped
    where objective_sales is not null

)

select * from renamed