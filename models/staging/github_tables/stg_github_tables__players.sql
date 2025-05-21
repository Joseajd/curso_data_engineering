{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select *
    from {{ ref('base_atp_all') }}
), players_union as (
    select 
        winner_id,
        winner_name,
        winner_hand,
        winner_ioc,
        winner_height
    from base

    union 

    select 
        loser_id,
        loser_name,
        loser_hand,
        loser_ioc,
        loser_height
    from base 
), players_renamed as (
    select 
        {{dbt_utils.generate_surrogate_key(['winner_name', 'winner_id'])}} as player_id,
        winner_name as player_name,
        winner_hand as player_hand,
        md5(winner_ioc) as player_ioc_id,
        winner_height as player_height
    from players_union
    group by player_id, player_name, player_hand, player_ioc_id, player_height
)

select * from players_renamed