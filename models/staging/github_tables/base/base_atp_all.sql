                                                                                                                                                                                                                          {{
    config(
        materialized='view'
    )
}}

with atp_all as (
    select * 
    from {{ source('github_tables', 'ATP_2000')}}
),
cleaned as (
    select 
    tourney_id,
    tourney_name,
    surface,
    CAST(draw_size as int) as draw_size,
    tourney_level,
    TO_DATE(tourney_date, 'YYYYMMDD') as tourney_start_date ,
    CAST(match_num as int) as match_number,
    winner_id,
    CAST(winner_seed as int) as winner_seed,
    UPPER(winner_entry) as winner_entry,
    REPLACE(winner_name, '-', ' ') as winner_name,
    winner_hand,
    CAST(winner_ht as int) as winner_height,
    winner_ioc,
    CAST(winner_age as int) as winner_age,
    loser_id,
    CAST(loser_seed as int) as loser_seed,
    UPPER(loser_entry) as loser_entry,
    REPLACE(loser_name, '-', ' ') as loser_name,
    loser_hand,
    CAST(loser_ht as int) as loser_height,
    loser_ioc,
    CAST(loser_age as int) as loser_age,
    regexp_replace(score, '\\(.*?\\)', '') as score,
    CAST(minutes as int ) as minutes,
    CAST(best_of as int) as best_of,
    round,
    CAST(w_ace as int) as winner_ace,
    CAST(w_df as int) as winner_double_faults,
    CAST(w_svpt as int) as winner_serve_points,
    CAST(w_1stIn as int) as winner_first_serve_in,
    CAST(w_1stWon as int) as winner_first_serve_won,
    CAST(w_2ndWon as int) as winner_second_serve_won,
    CAST(w_SvGms as int) as winner_serve_games_won,
    CAST(w_bpSaved as int) as winner_break_points_saved,
    CAST(w_bpFaced as int) as winner_break_points_faced,
    CAST(l_ace as int) as loser_ace,
    CAST(l_df as int) as loser_double_faults,
    CAST(l_svpt as int) as loser_serve_points,
    CAST(l_1stIn as int) as loser_first_serve_in,
    CAST(l_1stWon as int) as loser_first_serve_won,
    CAST(l_2ndWon as int) as loser_second_serve_won,
    CAST(l_SvGms as int) as loser_serve_games_won,
    CAST(l_bpSaved as int) as loser_break_points_saved,
    CAST(l_bpFaced as int) as loser_break_points_faced,
    CAST(winner_rank as int) as winner_rank,
    CAST(winner_rank_points as int) as winner_rank_points,
    CAST(loser_rank as int) as loser_rank,
    CAST(loser_rank_points as int) as loser_rank_points
    
    from atp_all
    where tourney_level in ('M', 'A', 'G', 'F') AND tourney_name not like '%Olympics%' AND tourney_name not like '%Laver%'
)

select * from cleaned