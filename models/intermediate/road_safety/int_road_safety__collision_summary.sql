with collisions as (

    select *
    from {{ ref('stg_road_safety__collisions') }}

),

casualty_summary as (

    select
        collision_index,
        count(*) as number_of_casualties,
        count_if(casualty_severity = 1) as number_of_fatal_casualties,
        count_if(casualty_severity = 2) as number_of_serious_casualties,
        count_if(casualty_severity = 3) as number_of_slight_casualties
    from {{ ref('stg_road_safety__casualties') }}
    group by collision_index

),

vehicle_summary as (

    select
        collision_index,
        count(*) as number_of_vehicles
    from {{ ref('stg_road_safety__vehicles') }}
    group by collision_index

),

final as (

    select
        collisions.* exclude (number_of_casualties, number_of_vehicles),
        coalesce(casualty_summary.number_of_casualties, 0) as number_of_casualties,
        coalesce(casualty_summary.number_of_fatal_casualties, 0) as number_of_fatal_casualties,
        coalesce(casualty_summary.number_of_serious_casualties, 0) as number_of_serious_casualties,
        coalesce(casualty_summary.number_of_slight_casualties, 0) as number_of_slight_casualties,
        coalesce(vehicle_summary.number_of_vehicles, 0) as number_of_vehicles
    from collisions
    left join casualty_summary
        on collisions.collision_index = casualty_summary.collision_index
    left join vehicle_summary
        on collisions.collision_index = vehicle_summary.collision_index

)

select *
from final