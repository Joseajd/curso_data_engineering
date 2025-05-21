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
        tourney_start_date as tournament_start_date,
        CONCAT(winner_name, '-', loser_name) as match_players,
        match_number,
        {{dbt_utils.generate_surrogate_key(['winner_name', 'winner_id'])}} as winner_id,
        {{replace_nulls(['winner_seed'])}},
        case 
            when winner_entry is null then 'DA'
            else winner_entry
        end as winner_entry,
        {{dbt_utils.generate_surrogate_key(['loser_name', 'loser_id'])}} as loser_id,
        {{replace_nulls(['loser_seed'])}},
        case
            when loser_entry is null then 'DA'
            else loser_entry
        end as loser_entry,
        score,
        split_part(score, ' ', 1) as set_1,
        split_part(score, ' ', 2) as set_2,
        split_part(score, ' ', 3) as set_3,
        split_part(score, ' ', 4) as set_4,
        split_part(score, ' ', 5) as set_5,
        {{replace_nulls(['minutes'])}},
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
        tournament_start_date,
        match_players,
        match_number,
        winner_id,
        winner_seed,
        md5(winner_entry) as winner_entry_id,
        loser_id,
        loser_seed,
        md5(loser_entry) as loser_entry_id,
        score,
        {{replace_nulls2(['set_1', 'set_2', 'set_3', 'set_4', 'set_5'])}},
        minutes,
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
), real_final as (
    select 
        match_id,
        tournament_id,
        tournament_start_date,
        match_players,
        match_number,
        winner_id,
        winner_seed,
        winner_entry_id,
        loser_id,
        loser_seed,
        loser_entry_id,
        score,
        set_1,
        set_2,
        set_3,
        set_4,
        set_5,
        cast(
        case 
            when set_1 ilike '%RET%' or set_1 ilike '%W/O%' or set_1 ilike '%DEF%' then 0
            else split_part(set_1, '-', 1)
        end as int
        ) as winner_games_set_1,
        cast(
        case 
            when set_1 ilike '%RET%' or set_1 ilike '%W/O%' or set_1 ilike '%DEF%' then 0
            else split_part(set_1, '-', 2)
        end as int
        ) as loser_games_set_1,
        cast(
        case 
            when set_2 ilike '%RET%' or set_2 ilike '%W/O%' or set_2 ilike '%DEF%' then 0
            else split_part(set_2, '-', 1)
        end as int
        ) as winner_games_set_2,
        cast(
        case 
            when set_2 ilike '%RET%' or set_2 ilike '%W/O%' or set_2 ilike '%DEF%' then 0
            else split_part(set_2, '-', 2)
        end as int
        ) as loser_games_set_2,
        cast(
        case 
            when set_3 ilike '%RET%' or set_3 ilike '%W/O%' or set_3 ilike '%DEF%' then 0
            else split_part(set_3, '-', 1)
        end as int
        ) as winner_games_set_3,
        cast(
        case 
            when set_3 ilike '%RET%' or set_3 ilike '%W/O%' or set_3 ilike '%DEF%' then 0
            else split_part(set_3, '-', 2)
        end as int
        ) as loser_games_set_3,
        cast(
        case 
            when set_4 ilike '%RET%' or set_4 ilike '%W/O%' or set_4 ilike '%DEF%'then 0
            else split_part(set_4, '-', 1)
        end as int
        ) as winner_games_set_4,
        cast(
        case 
            when set_4 ilike '%RET%' or set_4 ilike '%W/O%' or set_4 ilike '%DEF%' then 0
            else split_part(set_4, '-', 2)
        end as int
        ) as loser_games_set_4,
        cast(
        case 
            when set_5 ilike '%RET%' or set_5 ilike '%W/O%' or set_5 ilike '%DEF%' then 0
            else split_part(set_5, '-', 1)
        end as int
        ) as winner_games_set_5,
        cast(
        case 
            when set_5 ilike '%RET%' or set_5 ilike '%W/O%' or set_5 ilike '%DEF%' then 0
            else split_part(set_5, '-', 2)
        end as int
        ) as loser_games_set_5,
        case
            when set_1 like '%RET%' or set_2 like '%RET%' or set_3 like '%RET%' or set_4 like '%RET%' or set_5 like '%RET%' then 'True'
            when set_1 like '%W/O%' or set_2 like '%W/O%' or set_3 like '%W/O%' or set_4 like '%W/O%' or set_5 like '%W/O%' then 'True'
            when set_1 like '%DEF%' or set_2 like '%DEF%' or set_3 like '%DEF%' or set_4 like '%DEF%' or set_5 like '%DEF%' then 'True'
            else 'False'
        end as Retirement,
        winner_games_set_1+winner_games_set_2+winner_games_set_3+winner_games_set_4+winner_games_set_5 as total_winner_games,
        loser_games_set_1+loser_games_set_2+loser_games_set_3+loser_games_set_4+loser_games_set_5 as total_loser_games,
        winner_games_set_1+winner_games_set_2+winner_games_set_3+winner_games_set_4+winner_games_set_5+loser_games_set_1+loser_games_set_2+loser_games_set_3+loser_games_set_4+loser_games_set_5 as total_match_games,
        minutes,
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
    from final
)

select * from real_final







