{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select * 
    from {{ ref('base_atp_all')}}
), renamed_tournaments as (
    select 
        {{ dbt_utils.generate_surrogate_key(['tourney_name', 'tourney_start_date'])}} as tournament_id, 
        tourney_name as tournament_name,
        tourney_start_date as tournament_start_date,
        surface as tournament_surface,
        tourney_level as tournament_level,
        draw_size
    from base 
    group by tournament_name, tournament_surface, tournament_level, tournament_start_date
    order by tournament_start_date
)

select * from renamed_tournaments