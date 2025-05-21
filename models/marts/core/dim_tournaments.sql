{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select * 
    from {{ref('stg_github_tables__tournaments')}}
), dimension as (
    select 
        tournament_id,
        tournament_name,
        tournament_level,
        case 
            when tournament_level = 'A' then 'ATP 250 - ATP 500'
            when tournament_level = 'G' then 'Grand Slam'
            when tournament_level = 'M' then 'Masters'
            when tournament_level = 'F' then 'Finals'
        end as tournament_level_description,
        draw_size
    from staging
)

select * from dimension