{{config(
    materialized= 'table'
    )
}}

with staging as (
    select * 
    from {{ref('stg_github_tables__surfaces')}}
), dimension as (
    select 
        surface_id,
        surface,
        surface_speed,
        bounce_level,
        indoor_outdoor
    from staging
)

select * from dimension