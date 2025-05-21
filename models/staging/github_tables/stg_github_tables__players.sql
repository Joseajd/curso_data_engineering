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
        winner_ioc
    from base

    union 

    select 
        loser_id,
        loser_name,
        loser_hand,
        loser_ioc
    from base 
), players_renamed as (
    select 
        distinct {{dbt_utils.generate_surrogate_key(['winner_name', 'winner_id'])}} as player_id,
        winner_name as player_name,
        case
            when winner_hand = 'R' or winner_hand = 'L' then winner_hand
            else 'R'
        end as player_hand,
        md5(winner_ioc) as player_ioc_id
    from players_union
)

select * from players_renamed