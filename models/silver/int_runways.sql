select 
  runway_id,
  airport_ident,
  runway_length_ft,
  runway_width_ft,
  COALESCE(NULLIF(TRIM(runway_surface), ''), '__UNKNOWN__') AS runway_surface,
  runway_lighted,
  runway_closed
from {{ ref('stg_runways') }}