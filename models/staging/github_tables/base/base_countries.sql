{{
    config(
    materialized='view'
    )
}}

with countries as (
    select * 
    from {{ source('github_tables', 'countries')}}
), renamed as (
    select
    siglas as ioc,
    pais as country_name

    from countries
)

select * from renamed