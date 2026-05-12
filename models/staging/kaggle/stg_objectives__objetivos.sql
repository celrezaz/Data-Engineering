with

canonical as (
    select name from {{ ref('canonical_sales_reps') }}
),

scored as (

    select
        o.*,
        c.name                                as canonical_name,
        case
            when lower(trim(to_varchar(o.name_sales_rep))) in ('na', '') or o.name_sales_rep is null
                then null
            else jarowinkler_similarity(
                lower(trim(regexp_replace(to_varchar(o.name_sales_rep), '[^a-zA-Z0-9 ]', ''))),
                lower(c.name)
            )
        end                                   as similarity_score
    from {{ source('kaggle', 'objectives') }} o
    cross join canonical c

),

best_match as (
    select *
    from scored
    qualify row_number() over (
        partition by name_sales_rep, sales_team, month, year
        order by similarity_score desc nulls last
    ) = 1

),

source as (

    select
        name_sales_rep,

        case
            when lower(trim(to_varchar(name_sales_rep))) in ('na', '') or name_sales_rep is null
                then 'Unknown'
            when similarity_score > 75
                then canonical_name
            else 'Unknown'
        end                                   as name_sales_rep_clean,

        case
            when trim(lower(regexp_replace(to_varchar(sales_team), '[^a-zA-Z0-9 ]', ''))) in ('alfa', 'al fa', 'alpha')
                then 'Alfa'
            when trim(lower(regexp_replace(to_varchar(sales_team), '[^a-zA-Z0-9 ]', ''))) in ('bravo', 'brav0')
                then 'Bravo'
            when trim(lower(regexp_replace(to_varchar(sales_team), '[^a-zA-Z0-9 ]', ''))) in ('charlie', 'charli')
                then 'Charlie'
            when trim(lower(regexp_replace(to_varchar(sales_team), '[^a-zA-Z0-9 ]', ''))) in ('delta', 'delt a')
                then 'Delta'
            when lower(trim(to_varchar(sales_team))) in ('na', '') or sales_team is null
                then 'Unknown'
            else to_varchar(sales_team)
        end                                   as sales_team,

        month,
        {{ numero_mes('month') }}             as month_number,
        year,
        try_to_decimal(
            replace(trim(objective), ',', '.'), 10, 3
        )                                     as objective_sales,

        similarity_score

    from best_match

),

deduped as (

    select *
    from source
    qualify row_number() over (
        partition by {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean', 'year', 'month_number']) }}
        order by similarity_score desc nulls last
    ) = 1

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean', 'year', 'month_number']) }}    as objetivo_id,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean']) }}                            as sales_rep_id,
        {{ mes_code('year', 'month_number') }}                                                      as mes_id,
        objective_sales

    from deduped
    where objective_sales is not null

)

select * from renamed