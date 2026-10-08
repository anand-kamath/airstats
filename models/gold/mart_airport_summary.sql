{{ config(
    materialized = 'table'
) }}

WITH runway_summary AS (

    SELECT
        airport_ident,

        COUNT(DISTINCT runway_id) AS runway_count,

        SUM(runway_length_ft) AS total_runway_length_ft,

        MAX(runway_length_ft) AS max_runway_length_ft,

        AVG(runway_width_ft) AS avg_runway_width_ft

    FROM {{ ref('int_runways') }}

    GROUP BY airport_ident

),

comment_summary AS (

    SELECT
        airport_ident,

        COUNT(DISTINCT comment_id) AS comment_count

    FROM {{ ref('int_airport_comments') }}

    GROUP BY airport_ident

)

SELECT

    -- Airport attributes
    a.airport_ident,
    a.airport_name,
    a.airport_lat,
    a.airport_long,
    a.airport_type,
    a.continent,
    a.iso_country,
    a.iso_region,

    -- Runway metrics
    COALESCE(r.runway_count, 0) AS runway_count,
    COALESCE(r.total_runway_length_ft, 0) AS total_runway_length_ft,
    r.max_runway_length_ft,
    r.avg_runway_width_ft,

    -- Comment metrics
    COALESCE(c.comment_count, 0) AS comment_count,

    -- Indicators
    CASE
        WHEN COALESCE(r.runway_count, 0) > 0
            THEN TRUE
        ELSE FALSE
    END AS has_runways,

    CASE
        WHEN COALESCE(c.comment_count, 0) > 0
            THEN TRUE
        ELSE FALSE
    END AS has_comments

FROM {{ ref('int_airports') }} a

LEFT JOIN runway_summary r
    ON a.airport_ident = r.airport_ident

LEFT JOIN comment_summary c
    ON a.airport_ident = c.airport_ident