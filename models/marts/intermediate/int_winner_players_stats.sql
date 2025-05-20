{{
    config(
    materialized= 'table'
    )
}}

with staging as (
    select *
    from {{ref('stg_github_tables__matches_stats')}}
), int1 as (
    select 
        winner_id,
        count(winner_id) as total_wins,
        sum(winner_games_set_1) as total_games_set_1,
        sum(winner_games_set_2) as total_games_set_2,
        sum(minutes) as total_winner_minutes

    from staging
    group by winner_id    
)

select * from int1