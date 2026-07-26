{{ config(materialized='table') }}

select *
from {{ ref('int_road_safety__collision_summary') }}