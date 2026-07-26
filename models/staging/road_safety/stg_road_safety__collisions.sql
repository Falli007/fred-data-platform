with source as (

    select *
    from {{ source('road_safety', 'collisions') }}

),

renamed as (

    select
        nullif(trim("collision_index"::varchar), '') as collision_index,
        try_to_number("collision_year"::varchar) as collision_year,
        nullif(trim("collision_ref_no"::varchar), '') as collision_reference,
        try_to_number("location_easting_osgr"::varchar) as location_easting_osgr,
        try_to_number("location_northing_osgr"::varchar) as location_northing_osgr,
        try_to_double("longitude"::varchar) as longitude,
        try_to_double("latitude"::varchar) as latitude,
        try_to_number("police_force"::varchar) as police_force,
        try_to_number("collision_severity"::varchar) as collision_severity,
        try_to_number("number_of_vehicles"::varchar) as number_of_vehicles,
        try_to_number("number_of_casualties"::varchar) as number_of_casualties,
        try_to_date("date"::varchar, 'DD/MM/YYYY') as collision_date,
        try_to_number("day_of_week"::varchar) as day_of_week,
        try_to_time("time"::varchar) as collision_time,
        try_to_number("local_authority_district"::varchar) as local_authority_district,
        nullif(trim("local_authority_ons_district"::varchar), '') as local_authority_ons_district,
        nullif(trim("local_authority_highway"::varchar), '') as local_authority_highway,
        nullif(trim("local_authority_highway_current"::varchar), '') as local_authority_highway_current,
        try_to_number("first_road_class"::varchar) as first_road_class,
        try_to_number("first_road_number"::varchar) as first_road_number,
        try_to_number("road_type"::varchar) as road_type,
        try_to_number("speed_limit"::varchar) as speed_limit,
        try_to_number("junction_detail_historic"::varchar) as junction_detail_historic,
        try_to_number("junction_detail"::varchar) as junction_detail,
        try_to_number("junction_control"::varchar) as junction_control,
        try_to_number("second_road_class"::varchar) as second_road_class,
        try_to_number("second_road_number"::varchar) as second_road_number,
        try_to_number("pedestrian_crossing_human_control_historic"::varchar) as pedestrian_crossing_human_control_historic,
        try_to_number("pedestrian_crossing_physical_facilities_historic"::varchar) as pedestrian_crossing_physical_facilities_historic,
        try_to_number("pedestrian_crossing"::varchar) as pedestrian_crossing,
        try_to_number("light_conditions"::varchar) as light_conditions,
        try_to_number("weather_conditions"::varchar) as weather_conditions,
        try_to_number("road_surface_conditions"::varchar) as road_surface_conditions,
        try_to_number("special_conditions_at_site"::varchar) as special_conditions_at_site,
        try_to_number("carriageway_hazards_historic"::varchar) as carriageway_hazards_historic,
        try_to_number("carriageway_hazards"::varchar) as carriageway_hazards,
        try_to_number("urban_or_rural_area"::varchar) as urban_or_rural_area,
        try_to_number("did_police_officer_attend_scene_of_accident"::varchar) as did_police_officer_attend_scene,
        try_to_number("trunk_road_flag"::varchar) as trunk_road_flag,
        nullif(trim("lsoa_of_accident_location"::varchar), '') as lsoa_of_accident_location,
        try_to_number("enhanced_severity_collision"::varchar) as enhanced_severity_collision,
        try_to_number("collision_injury_based"::varchar) as collision_injury_based,
        try_to_number("collision_adjusted_severity_serious"::varchar) as collision_adjusted_severity_serious,
        try_to_number("collision_adjusted_severity_slight"::varchar) as collision_adjusted_severity_slight
    from source

)

select *
from renamed
