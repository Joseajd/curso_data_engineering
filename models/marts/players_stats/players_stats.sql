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
        s.winner_id as player_id,
        d.player_name as player_name,
        d.country_name as player_country,
        d.player_hand as player_hand,
        1 as matches_played,
        1 as matches_won,
        0 as matches_lost,
        s.minutes,
        s.winner_games_set_1 as set_1_games,
        s.winner_games_set_2 as set_2_games,
        s.winner_games_set_3 as set_3_games,
        s.winner_games_set_4 as set_4_games,
        s.winner_games_set_5 as set_5_games,
        s.total_winner_games as games_won,
        s.winner_ace as aces,
        case   
            when s.Retirement = 'True' then 1
            else 0
        end as retirements,
        s.winner_double_faults as double_faults,
        s.winner_serve_points as serve_points,
        s.winner_first_serve_in as first_serve_in,
        s.winner_first_serve_won as first_serve_won,
        s.winner_second_serve_won as second_serve_won,
        s.winner_serve_games_won as serve_games_won,
        s.winner_break_points_faced as break_points_faced,
        s.winner_break_points_saved as break_points_saved
    from staging s
    join {{ref('dim_players')}} d on s.winner_id = d.player_id
), loser as (
    select 
        s.loser_id as player_id,
        d.player_name as player_name,
        d.country_name as player_country,
        d.player_hand as player_hand,
        1 as matches_played,
        0 as matches_won,
        1 as matches_lost,
        s.minutes,
        s.loser_games_set_1 as set_1_games,
        s.loser_games_set_2 as set_2_games,
        s.loser_games_set_3 as set_3_games,
        s.loser_games_set_4 as set_4_games,
        s.loser_games_set_5 as set_5_games,
        s.total_loser_games as games_won,
        s.loser_ace as aces,
        case   
            when s.Retirement = 'True' then 1
            else 0
        end as retirements,
        s.loser_double_faults as double_faults,
        s.loser_serve_points as serve_points,
        s.loser_first_serve_in as first_serve_in,
        s.loser_first_serve_won as first_serve_won,
        s.loser_second_serve_won as second_serve_won,
        s.loser_serve_games_won as serve_games_won,
        s.loser_break_points_faced as break_points_faced,
        s.loser_break_points_saved as break_points_saved
    from staging s
    join {{ref('dim_players')}} d on s.winner_id = d.player_id
), combinada as (
    select * 
    from winner
    union all 
    select * 
    from loser
), final as (
    select 
        player_id,
        player_name,
        player_country,
        player_hand,
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
    group by player_id, player_name, player_country, player_hand
), last_stats as (
    select 
        player_id,
        player_name,
        player_country,
        player_hand,
        total_matches_played,
        total_matches_won,
        total_matches_lost,
       trunc((total_matches_won/total_matches_played)*100, 2) as pct_wins,
        trunc((total_matches_lost/total_matches_played)*100, 2) as pct_looses,
        total_minutes,
        (total_minutes/total_matches_played) as avg_mins_per_match,
        total_retirements,
        total_set_1_games,
        total_set_2_games,
        total_set_3_games,
        total_set_4_games,
        total_set_5_games,
        total_games_won,
        total_aces,
        total_double_faults,
        total_serve_points,
        total_first_serve_won,
        total_first_serve_in,
        trunc(case
            when total_first_serve_in = 0 then 0
            else (total_first_serve_won/total_first_serve_in)*100 
        end, 2)  as ratio_first_serve,
        total_second_serve_won,
        total_serve_games_won,
       trunc(case
            when total_games_won = 0 then 0
            else (total_serve_games_won/total_games_won)*100 
        end, 2) as ratio_serve_games,
        total_break_points_faced,
        total_break_points_saved,
       trunc(case
            when total_break_points_faced = 0 then 0
            else (total_break_points_saved/total_break_points_faced)*100 
        end, 2) as pct_tbps_tbpf
    from final
)


select * from last_stats