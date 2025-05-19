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
        {{ dbt_utils.generate_surrogate_key(['winner_name', 'loser_name', 'tourney_start_date', 'tourney_name', 'match_number'])}} as match_id,
        {{ dbt_utils.generate_surrogate_key(['tourney_name', 'tourney_start_date'])}} as tournament_id,
        CONCAT(winner_name, '-', loser_name) as match_players,
        match_number,
        md5(winner_name) as winner_id,
        {{replace_nulls(['winner_seed'])}},
        case 
            when winner_entry is null then 'DA'
            else winner_entry
        end as winner_entry,
        winner_age,
        md5(loser_name) as loser_id,
        {{replace_nulls(['loser_seed'])}},
        case
            when loser_entry is null then 'DA'
            else loser_entry
        end as loser_entry,
        loser_age,
        score,
        best_of,
        round,
        {{replace_nulls(['winner_ace',
        'winner_double_faults',
        'winner_serve_points',
        'winner_first_serve_in',
        'winner_first_serve_won',
        'winner_second_serve_won',
        'winner_serve_games_won',
        'winner_break_points_saved',
        'winner_break_points_faced',
        'loser_ace',
        'loser_double_faults',
        'loser_serve_points',
        'loser_first_serve_in',
        'loser_first_serve_won',
        'loser_second_serve_won',
        'loser_serve_games_won',
        'loser_break_points_saved',
        'loser_break_points_faced'])}},
        winner_rank,
        winner_rank_points,
        loser_rank,
        loser_rank_points

    from base
), final as (
    select 
        match_id,
        tournament_id,
        match_players,
        match_number,
        winner_id,
        winner_seed,
        md5(winner_entry) as winner_entry_id,
        winner_age,
        loser_id,
        md5(loser_entry) as loser_entry_id,
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

    from hashed
)

select * from final