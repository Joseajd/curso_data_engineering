{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select *
    from {{ref('stg_github_tables__entry_modes')}}
), dimension as (
    select 
        entry_mode_id,
        entry_mode,
        entry_description
    from staging
)

select * from dimension