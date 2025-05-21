{{
    config(
        materialized= 'table'
    )
}}

with staging as (
    select *
    from {{ref('stg_date')}}
), dimension as (
    select 
        date_id,
        year,
        quarter,
        month,
        month_name,
        day,
        week_day
    from staging
)

select * from dimension