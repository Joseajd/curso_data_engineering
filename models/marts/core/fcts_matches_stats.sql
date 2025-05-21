{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select * 
    from {{ref('stg_github_tables__matches_stats')}}
), facts as (
    select 
        s.match_id,
        s.tournament_id,
        t.surface_id,
        s.tournament_start_date,
        s.match_players,
        s.match_number,
        s.winner_id,
        s.winner_seed,
        s.winner_entry_id,
        s.loser_id,
        s.loser_seed,
        s.loser_entry_id,
        s.score,
        s.set_1,
        s.set_2,
        s.set_3,
        s.set_4,
        s.set_5,
        s.winner_games_set_1,
        s.loser_games_set_1,
        s.winner_games_set_2,
        s.loser_games_set_2,
        s.winner_games_set_3,
        s.loser_games_set_3,
        s.winner_games_set_4,
        s.loser_games_set_4,
        s.winner_games_set_5,
        s.loser_games_set_5,
        s.Retirement,
        s.total_winner_games,
        s.total_loser_games,
        s.total_match_games,
        s.minutes,
        s.best_of,
        md5(s.round) as round_id,
        s.winner_ace,
        s.winner_double_faults,
        s.winner_serve_points,
        s.winner_first_serve_in,
        s.winner_first_serve_won,
        s.winner_second_serve_won,
        s.winner_serve_games_won,
        s.winner_break_points_saved,
        s.winner_break_points_faced,
        s.loser_ace,
        s.loser_double_faults,
        s.loser_serve_points,
        s.loser_first_serve_in,
        s.loser_first_serve_won,
        s.loser_second_serve_won,
        s.loser_serve_games_won,
        s.loser_break_points_saved,
        s.loser_break_points_faced,
        s.winner_rank,
        s.winner_rank_points,
        s.loser_rank,
        s.loser_rank_points

    from staging s
    join {{ref('stg_github_tables__tournaments')}} t on s.tournament_id = t.tournament_id
)

select * from facts