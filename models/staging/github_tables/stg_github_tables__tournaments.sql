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
        tourney_name as tournament_name,
        surface as tournament_surface,
        tourney_level as tournament_level,
        tourney_start_date as tournament_start_date,
    from base 
)

select * from renamed_tournaments