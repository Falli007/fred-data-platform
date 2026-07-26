with source as (

    select *
    from {{ source('road_safety', 'casualties') }}

),

renamed as (

    select
        cast("collision_index" as varchar) as collision_index,
        cast("collision_year" as integer) as collision_year,
        cast("collision_ref_no" as varchar) as collision_reference_number,
        cast("vehicle_reference" as integer) as vehicle_reference,
        cast("casualty_reference" as integer) as casualty_reference,
        cast("casualty_class" as integer) as casualty_class,
        cast("sex_of_casualty" as integer) as sex_of_casualty,
        cast("age_of_casualty" as integer) as age_of_casualty,
        cast("age_band_of_casualty" as integer) as age_band_of_casualty,
        cast("casualty_severity" as integer) as casualty_severity,
        cast("pedestrian_location" as integer) as pedestrian_location,
        cast("pedestrian_movement" as integer) as pedestrian_movement,
        cast("car_passenger" as integer) as car_passenger,
        cast("bus_or_coach_passenger" as integer) as bus_or_coach_passenger,
        cast("pedestrian_road_maintenance_worker" as integer) as pedestrian_road_maintenance_worker,
        cast("casualty_type" as integer) as casualty_type,
        cast("casualty_imd_decile" as integer) as casualty_imd_decile,
        cast("lsoa_of_casualty" as varchar) as casualty_lsoa,
        cast("enhanced_casualty_severity" as integer) as enhanced_casualty_severity,
        cast("casualty_injury_based" as integer) as casualty_injury_based,
        cast("casualty_adjusted_severity_serious" as number(18, 10)) as casualty_adjusted_severity_serious,
        cast("casualty_adjusted_severity_slight" as number(18, 10)) as casualty_adjusted_severity_slight,
        cast("casualty_distance_banding" as integer) as casualty_distance_banding
    from source

)

select *
from renamed