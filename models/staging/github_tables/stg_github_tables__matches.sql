{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select * 
    from {{ref('base_atp_all')}}
), hashed as (
    select 
        {{ dbt_utils.generate_surrogate_key(['winner_name', 'loser_name', 'tourney_start_date', 'tourney_name'])}} as match_id,
        {{ dbt_utils.generate_surrogate_key(['tourney_name', 'tourney_start_date'])}} as tournament_id,
        CONCAT(winner_name, '-', loser_name) as match_players,
        winner_id,
        winner_seed,
        winner_entry,
        winner_age,
        loser_id,
        loser_seed,
        loser_entry,
        loser_age,
        score,
        best_of,
        round,
        winner_ace,
        winner_double_faults,
        winner_serve_points,
        winner_first_serve_in,
        winner_first_serve_won,
        winner_second_serve_won,
        winner_serve_games_won,
        winner_break_points_saved,
        winner_break_points_faced,
        loser_ace,
        loser_double_faults,
        loser_serve_points,
        loser_first_serve_in,
        loser_first_serve_won,
        loser_second_serve_won,
        loser_serve_games_won,
        loser_break_points_saved,
        loser_break_points_faced,
        winner_rank,
        winner_rank_points,
        loser_rank,
        loser_rank_points

    from base
)

select * from hashed