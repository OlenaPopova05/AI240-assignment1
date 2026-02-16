CREATE TABLE asteroids AS
SELECT *
FROM read_json_auto('/PATH/TO/nasa_asteroids.json');


SELECT *
FROM asteroids_unnested
LIMIT 10;

DROP TABLE IF EXISTS asteroids_unnested;
CREATE TABLE asteroids_unnested AS
SELECT
    id,
    name,
    absolute_magnitude_h,
    (CAST(json_extract_string(estimated_diameter, '$.kilometers.estimated_diameter_min') AS DOUBLE) +
     CAST(json_extract_string(estimated_diameter, '$.kilometers.estimated_diameter_max') AS DOUBLE)) / 2
        AS avg_diameter_km,
    CAST(is_potentially_hazardous_asteroid AS BOOLEAN) AS is_potentially_hazardous_asteroid,
    CAST(json_extract_string(nested_data, '$.close_approach_date') AS DATE) AS close_approach_date,
    json_extract_string(nested_data, '$.close_approach_date_full') AS close_approach_date_full,
    CAST(json_extract_string(nested_data, '$.relative_velocity.kilometers_per_hour') AS DOUBLE) AS velocity_kph,
    CAST(json_extract_string(nested_data, '$.miss_distance.kilometers') AS DOUBLE) AS miss_distance_km
FROM asteroids,
    UNNEST(close_approach_data) AS cad(nested_data);


-- The month with the biggest amount of hazardous asteroid observed
-- This allows us to determine the level of danger from asteroids each month.
-- Create CTEs (Common Table Expression) as base temporary tables inside the query (to create month elias and avoid repetitions).
WITH base AS (
    SELECT
        close_approach_date,
        is_potentially_hazardous_asteroid,
        DATE_TRUNC('month', close_approach_date) AS month
    FROM asteroids_unnested
),
by_month AS (
    SELECT
    month,
    COUNT(*) OVER (PARTITION BY month) AS total_asteroids_in_month,
    SUM(is_potentially_hazardous_asteroid)
        OVER (PARTITION BY month) AS hazardous_count_in_month
    FROM base
)
SELECT DISTINCT
    month,
    total_asteroids_in_month,
    hazardous_count_in_month,
    ROUND(hazardous_count_in_month * 100.0 / total_asteroids_in_month, 2) AS hazardous_percent_in_month
FROM by_month
ORDER BY hazardous_percent_in_month DESC, month;
-- June is the month with the highest percentage (6.2%) of potentially hazardous asteroids.



-- Top 3 closest asteroid approaches per month
SELECT *
FROM (
  SELECT
    DATE_TRUNC('month', close_approach_date) AS month,
    id,
    name,
    velocity_kph,
    miss_distance_km,
    is_potentially_hazardous_asteroid,
    ROW_NUMBER() OVER (
      PARTITION BY DATE_TRUNC('month', close_approach_date)
      ORDER BY miss_distance_km ASC
    ) AS ranked
  FROM asteroids_unnested
)
WHERE ranked <= 3
ORDER BY month DESC, ranked;
-- Only safe asteroids came closest to Earth, with the closest approach occurring in October.
