{{
    config(
        materialized= 'view'
    )
}}

with base as (
    select 
        case   
            when winner_entry is null then 'DA'
            else winner_entry
        end as winner_entry
    from {{ref('base_atp_all')}}

    union 

    select 
        case   
            when loser_entry is null then 'DA'
            else loser_entry
        end as loser_entry
    from {{ref('base_atp_all')}}
), entry_all as (
    select 
        distinct winner_entry as entry_mode
    from base
), entry_descriptions as (
    select 
        md5(entry_mode) as entry_mode_id,
        entry_mode,
        case
            when entry_mode = 'DA' then 'Direct Access'
            when entry_mode = 'ALT' then 'Alternate'
            when entry_mode = 'Q' then 'Qualified'
            when entry_mode = 'LL' then 'Lucky Loser'
            when entry_mode = 'SE' then 'Special Exception'
            when entry_mode = 'WC' then 'Wild Card'
            when entry_mode = 'PR' then 'Protected Ranking'
            when entry_mode = 'W' then 'Walkover'
            when entry_mode = 'S' then 'Suspended'
            
        end as entry_description
    from entry_all
)

select * from entry_descriptions