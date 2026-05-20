
with

canonical as (
    select name from {{ ref('canonical_sales_reps') }}
),

source_clean as (

    select
        o.*,
        case
            when trim(lower(regexp_replace(to_varchar(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('alfa', 'al fa', 'alpha')
                then 'Alfa'
            when trim(lower(regexp_replace(to_varchar(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('bravo', 'brav0')
                then 'Bravo'
            when trim(lower(regexp_replace(to_varchar(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('charlie', 'charli')
                then 'Charlie'
            when trim(lower(regexp_replace(to_varchar(o.sales_team), '[^a-zA-Z0-9 ]', ''))) in ('delta', 'delt a')
                then 'Delta'
            when lower(trim(to_varchar(o.sales_team))) in ('na', '') or o.sales_team is null
                then 'Unknown'
            else to_varchar(o.sales_team)
        end                                   as sales_team_clean
    from {{ source('kaggle', 'objectives') }} o

),

scored as (

    select
        s.*,
        c.name                                as canonical_name,
        case
            when lower(trim(to_varchar(s.name_sales_rep))) in ('na', '') or s.name_sales_rep is null
                then null
            else jarowinkler_similarity(
                lower(trim(regexp_replace(to_varchar(s.name_sales_rep), '[^a-zA-Z0-9 ]', ''))),
                lower(trim(regexp_replace(c.name, '[^a-zA-Z0-9 ]', '')))
            )
        end                                   as similarity_score
    from source_clean s
    cross join canonical c

),

best_match as (
    select *
    from scored
    qualify row_number() over (
        partition by name_sales_rep, sales_team_clean, month, year
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
        sales_team_clean                      as sales_team,
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

    select *, 
    {{ mes_code('year', 'month_number') }} as mes_id
    from source
    qualify row_number() over (
        partition by {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean', 'year', 'month_number']) }}
        order by similarity_score desc nulls last
    ) = 1

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean', 'mes_id']) }}  as objetivo_id,
        {{ dbt_utils.generate_surrogate_key(['name_sales_rep_clean']) }}            as sales_rep_id, 
        mes_id,                                                     
        objective_sales
    from deduped
    where objective_sales is not null

)

select * from renamed