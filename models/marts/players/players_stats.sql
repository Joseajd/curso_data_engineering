{{
    config(
    materialized= 'table'
    )
}}

with staging as (
    select *
    from {{ref('fcts_matches_stats')}}
), winner as (
    select 
        winner_id as player_id,
        1 as matches_played,
        1 as matches_won,
        0 as matches_lost,
        minutes,
        winner_games_set_1 as set_1_games,
        winner_games_set_2 as set_2_games,
        winner_games_set_3 as set_3_games,
        winner_games_set_4 as set_4_games,
        winner_games_set_5 as set_5_games,
        total_winner_games as games_won,
        winner_ace as aces,
        case   
            when Retirement = 'True' then 1
            else 0
        end as retirements,
        winner_double_faults as double_faults,
        winner_serve_points as serve_points,
        winner_first_serve_in as first_serve_in,
        winner_first_serve_won as first_serve_won,
        winner_second_serve_won as second_serve_won,
        winner_serve_games_won as serve_games_won,
        winner_break_points_faced as break_points_faced,
        winner_break_points_saved as break_points_saved
    from staging 
), loser as (
    select 
        loser_id as player_id,
        1 as matches_played,
        0 as matches_won,
        1 as matches_lost,
        minutes,
        loser_games_set_1 as set_1_games,
        loser_games_set_2 as set_2_games,
        loser_games_set_3 as set_3_games,
        loser_games_set_4 as set_4_games,
        loser_games_set_5 as set_5_games,
        total_loser_games as games_won,
        loser_ace as aces,
        case   
            when Retirement = 'True' then 1
            else 0
        end as retirements,
        loser_double_faults as double_faults,
        loser_serve_points as serve_points,
        loser_first_serve_in as first_serve_in,
        loser_first_serve_won as first_serve_won,
        loser_second_serve_won as second_serve_won,
        loser_serve_games_won as serve_games_won,
        loser_break_points_faced as break_points_faced,
        loser_break_points_saved as break_points_saved
    from staging 
), combinada as (
    select * 
    from winner
    union all 
    select * 
    from loser
), final as (
    select 
        player_id,
        sum(matches_played) as total_matches_played,
        sum(matches_won) as total_matches_won,
        sum(matches_lost) as total_matches_lost,
        sum(minutes) as total_minutes,
        sum(retirements) as total_retirements,
        sum(set_1_games) as total_set_1_games,
        sum(set_2_games) as total_set_2_games,
        sum(set_3_games) as total_set_3_games,
        sum(set_4_games) as total_set_4_games,
        sum(set_5_games) as total_set_5_games,
        sum(games_won) as total_games_won,
        sum(aces) as total_aces,
        sum(double_faults) as total_double_faults,
        sum(serve_points) as total_serve_points,
        sum(first_serve_in) as total_first_serve_in,
        sum(first_serve_won) as total_first_serve_won,
        sum(second_serve_won) as total_second_serve_won,
        sum(serve_games_won) as total_serve_games_won,
        sum(break_points_faced) as total_break_points_faced,
        sum(break_points_saved) as total_break_points_saved

    from combinada
    group by player_id
), last_stats as (
    select 
        f.player_id,
        p.player_name,
        p.country_name as player_country,
        p.player_hand,
        f.total_matches_played,
        f.total_matches_won,
        f.total_matches_lost,
       trunc((f.total_matches_won/f.total_matches_played)*100, 2) as pct_wins,
        trunc((f.total_matches_lost/f.total_matches_played)*100, 2) as pct_looses,
        f.total_minutes,
        (f.total_minutes/f.total_matches_played) as avg_mins_per_match,
        f.total_retirements,
        f.total_set_1_games,
        f.total_set_2_games,
        f.total_set_3_games,
        f.total_set_4_games,
        f.total_set_5_games,
        f.total_games_won,
        f.total_aces,
        f.total_double_faults,
        f.total_serve_points,
        f.total_first_serve_won,
        f.total_first_serve_in,
        trunc(case
            when f.total_first_serve_in = 0 then 0
            else (f.total_first_serve_won/f.total_first_serve_in)*100 
        end, 2)  as ratio_first_serve,
        f.total_second_serve_won,
        f.total_serve_games_won,
       trunc(case
            when f.total_games_won = 0 then 0
            else (f.total_serve_games_won/f.total_games_won)*100 
        end, 2) as ratio_serve_games,
        f.total_break_points_faced,
        f.total_break_points_saved,
       trunc(case
            when f.total_break_points_faced = 0 then 0
            else (f.total_break_points_saved/f.total_break_points_faced)*100 
        end, 2) as pct_tbps_tbpf
    from final f
    join {{ref('dim_players')}} p on p.player_id = f.player_id
)


select * from last_stats