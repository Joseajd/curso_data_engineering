select * 
from {{ref('stg_github_tables__matches_stats')}}
where winner_break_points_faced < winner_break_points_saved