{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select * 
    from {{ref('stg_github_tables__players')}}
), dimension as (
    select 
        s.player_id,
        s.player_name,
        c.country_name,
        s.player_hand,
        s.player_height
        
    from staging s
    join {{ref('stg_github_tables__countries')}} c on s.player_ioc_id = c.country_id
)

select * from dimension