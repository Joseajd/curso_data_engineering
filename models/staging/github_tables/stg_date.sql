{{
    config(
        materialized= 'table'
    )
}}

with fecha as (
    {{ dbt_utils.date_spine(
    datepart = "day",
    start_date = "'2000-01-01'",
    end_date = "'2024-12-31'"
) }}
), fecha_casteada as (
    select
        cast(date_day as date) as fecha,
    from fecha
), fecha_completa as (
    select 
        fecha as date_id, 
        year(fecha) as year,
        date_part(quarter, fecha) as quarter,
        month(fecha) as month,
        monthname(fecha) as month_name,
        day(fecha) as day,
        dayname(fecha) as week_day
    from fecha_casteada
)

select * from fecha_completa


