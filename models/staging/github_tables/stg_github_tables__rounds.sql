{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select distinct round
    from {{ref('base_atp_all')}}
), hashed as (
    select 
        md5(round) as round_id,
        round,
        case 
            when round = 'RR' then 'Round Robin'
            when round = 'ER' then 'Early Round'
            when round = 'BR' then 'Bronze Round'
            when round = 'R128' then 'Round of 128'
            when round = 'R64' then 'Round of 64'
            when round = 'R32' then 'Round of 32'
            when round = 'R16' then 'Round of 16'
            when round = 'QF' then 'Quarterfinals'
            when round = 'SF' then 'Semifinals'
            when round = 'F' then 'Final'
        end as round_description
    from base
    order by round
)

select * from hashed