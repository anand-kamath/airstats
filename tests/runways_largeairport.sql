{{
  config(
    severity = 'warn',
    )
}}
SELECT
    a.airport_ident,
    a.airport_name
FROM {{ ref('stg_airports') }} a
LEFT JOIN {{ ref('stg_runways') }} r
    ON a.airport_ident = r.airport_ident
WHERE a.airport_type = 'large_airport'
GROUP BY
    a.airport_ident,
    a.airport_name
HAVING COUNT(r.runway_id) = 0