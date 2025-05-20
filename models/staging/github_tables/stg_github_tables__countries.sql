{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select * 
    from {{ ref('base_countries')}}
), hashed as (
    select 
        md5(ioc) as country_id,
        country_name,
        ioc
    from base
)

select * from hashed