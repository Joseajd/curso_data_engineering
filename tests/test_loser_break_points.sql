select * 
from {{ref('stg_github_tables__matches_stats')}}
where loser_break_points_faced < loser_break_points_saved