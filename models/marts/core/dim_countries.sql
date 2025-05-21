{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select * 
    from {{ref('stg_github_tables__countries')}}
), dimension as (
    select 
        country_id,
        country_name,
        ioc
    from staging
)

select * from dimension