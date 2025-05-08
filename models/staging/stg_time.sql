with date_spine as (
    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2020-01-01' as date)",
        end_date = "cast('2023-12-31' as date)"
    ) }}
), renamed as (
    select 
        date_day,
        year(date_day) as year,
        month(date_day) as month,
        day(date_day) as day_number

    from date_spine
)

select * from renamed

