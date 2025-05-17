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
    select distinct
        md5(winner_name) as player_id,
        winner_name as player_name,
        winner_hand as player_hand,
        winner_ioc as player_ioc,
        winner_height as player_height
    from players_union
)

select * from players_renamed