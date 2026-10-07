{{ config(
    materialized='table'
) }}

WITH airport_summary AS (

    SELECT
        a.airport_ident,
        a.airport_name,
        a.airport_lat,
        a.airport_long,
        a.airport_type,
        a.iso_country,
        a.iso_region,

        -- Runway metrics
        COUNT(DISTINCT r.runway_id) AS runway_count,
        SUM(r.runway_length_ft) AS total_runway_length_ft,
        MAX(r.runway_length_ft) AS max_runway_length_ft,
        AVG(r.runway_width_ft) AS avg_runway_width_ft,

        -- Comment metrics
        COUNT(DISTINCT c.comment_id) AS comment_count,

        CASE
            WHEN COUNT(DISTINCT r.runway_id) > 0 THEN TRUE
            ELSE FALSE
        END AS has_runways,

        CASE
            WHEN COUNT(DISTINCT c.comment_id) > 0 THEN TRUE
            ELSE FALSE
        END AS has_comments

    FROM {{ ref('stg_airports') }} a

    LEFT JOIN {{ ref('stg_runways') }} r
        ON a.airport_ident = r.airport_ident

    LEFT JOIN {{ ref('stg_airport_comments') }} c
        ON a.airport_ident = c.airport_ident

    GROUP BY
        a.airport_ident,
        a.airport_name,
        a.airport_lat,
        a.airport_long,
        a.airport_type,
        a.iso_country,
        a.iso_region
)

SELECT *
FROM airport_summary