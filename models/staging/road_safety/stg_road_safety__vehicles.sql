with source as (

    select *
    from {{ source('road_safety', 'vehicles') }}

),

renamed as (

    select
        cast("collision_index" as varchar) as collision_index,
        cast("collision_year" as integer) as collision_year,
        cast("collision_ref_no" as varchar) as collision_reference_number,
        cast("vehicle_reference" as integer) as vehicle_reference,
        cast("vehicle_type" as integer) as vehicle_type,
        cast("towing_and_articulation" as integer) as towing_and_articulation,
        cast("vehicle_manoeuvre_historic" as integer) as vehicle_manoeuvre_historic,
        cast("vehicle_manoeuvre" as integer) as vehicle_manoeuvre,
        cast("vehicle_direction_from" as integer) as vehicle_direction_from,
        cast("vehicle_direction_to" as integer) as vehicle_direction_to,
        cast("vehicle_location_restricted_lane_historic" as integer) as vehicle_location_restricted_lane_historic,
        cast("vehicle_location_restricted_lane" as integer) as vehicle_location_restricted_lane,
        cast("junction_location" as integer) as junction_location,
        cast("skidding_and_overturning" as integer) as skidding_and_overturning,
        cast("hit_object_in_carriageway" as integer) as hit_object_in_carriageway,
        cast("vehicle_leaving_carriageway" as integer) as vehicle_leaving_carriageway,
        cast("hit_object_off_carriageway" as integer) as hit_object_off_carriageway,
        cast("first_point_of_impact" as integer) as first_point_of_impact,
        cast("vehicle_left_hand_drive" as integer) as vehicle_left_hand_drive,
        cast("journey_purpose_of_driver_historic" as integer) as journey_purpose_of_driver_historic,
        cast("journey_purpose_of_driver" as integer) as journey_purpose_of_driver,
        cast("sex_of_driver" as integer) as sex_of_driver,
        cast("age_of_driver" as integer) as age_of_driver,
        cast("age_band_of_driver" as integer) as age_band_of_driver,
        cast("engine_capacity_cc" as integer) as engine_capacity_cc,
        cast("propulsion_code" as integer) as propulsion_code,
        cast("age_of_vehicle" as integer) as age_of_vehicle,
        cast("generic_make_model" as varchar) as generic_make_model,
        cast("driver_imd_decile" as integer) as driver_imd_decile,
        cast("lsoa_of_driver" as varchar) as driver_lsoa,
        cast("escooter_flag" as integer) as escooter_flag,
        cast("driver_distance_banding" as integer) as driver_distance_banding
    from source

)

select *
from renamed