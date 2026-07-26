{{ config(materialized='table') }}

select
    collision_date,
    count(*) as total_collisions,
    sum(number_of_casualties) as total_casualties,
    sum(number_of_fatal_casualties) as fatal_casualties,
    sum(number_of_serious_casualties) as serious_casualties,
    sum(number_of_slight_casualties) as slight_casualties,
    sum(number_of_vehicles) as total_vehicles
from {{ ref('fct_road_safety__collisions') }}
group by collision_date