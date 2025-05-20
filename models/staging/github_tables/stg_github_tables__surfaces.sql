{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select distinct surface 
    from {{ref('base_atp_all')}}
), surfaces as (
    select 
        md5(surface) as surface_id,
        surface,
        case
            when surface='Clay' then 'Slow'
            when surface='Hard' then 'Fast'
            when surface='Grass' then 'Fast'
            when surface='Carpet' then 'Fast'
            end as surface_speed,
        
        case
            when surface='Clay' then 'High'
            when surface='Hard' then 'Medium'
            when surface='Grass' then 'Low'
            when surface='Carpet' then 'Low'
            end as bounce_level,
        
        case
            when surface='Clay' then 'Outdoor'
            when surface='Hard' then 'Outdoor/Indoor'
            when surface='Grass' then 'Outdoor'
            when surface='Carpet' then 'Indoor'
            end as indoor_outdoor

        from base

)

select * from surfaces