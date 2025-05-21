{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select * 
    from {{ref("stg_github_tables__rounds")}}
), dimension as (
    select 
        round_id,
        round,
        round_description
    from staging
)

select * from dimension