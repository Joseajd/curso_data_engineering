{% snapshot player_stats_evolution %}
{{
    config(
        target_schema='snapshots',
        unique_key='player_id',
        strategy='check',
        check_cols=['player_name', 'total_matches_played']
    )
}}

select * 
from {{ref('players_stats')}}

{%endsnapshot%}