with

source_raw as (

    select
        trim(to_varchar(product_name))  as product_name,
        case
            when lower(trim(to_varchar(product_class))) in ('na', '') or product_class is null
                then null
            else trim(to_varchar(product_class))
        end                             as product_class
    from {{ source('kaggle', 'farmacia') }}

),

canonical as (

    select
        product_name,
        product_class
    from {{ ref('canonical_product_class') }}

),

scored as (

    select
        s.product_name                  as source_product_name,
        s.product_class                 as source_product_class,
        c.product_name                  as canonical_product_name,
        c.product_class                 as canonical_product_class,
        jarowinkler_similarity(
            lower(trim(regexp_replace(s.product_name, '[^a-zA-Z0-9 ]', ''))),
            lower(trim(regexp_replace(c.product_name, '[^a-zA-Z0-9 ]', '')))
        )                               as similarity_score
    from source_raw s
    cross join canonical c
    where s.product_name is not null

),

best_match as (

    select *
    from scored
    qualify row_number() over (
        partition by source_product_name
        order by similarity_score desc nulls last
    ) = 1

),

enriched as (

    select
        s.product_name,
        case
            when s.product_class is not null
                then s.product_class
            when m.similarity_score > 75
                then m.canonical_product_class
            else null
        end                             as product_class
    from source_raw s
    left join best_match m
        on m.source_product_name = s.product_name

),

renamed as (

    select distinct
        {{ mayusculas_nombres('coalesce(product_class, \'Unknown\')') }}    as product_class,
        {{ dbt_utils.generate_surrogate_key(['product_class']) }}           as product_class_id
    from enriched

    union all

    select
        'Unknown'                                                           as product_class,
        {{ dbt_utils.generate_surrogate_key(['\'Unknown\'']) }}             as product_class_id

)

select distinct * from renamed