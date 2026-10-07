{{
  config(
    materialized = 'incremental',
    unique_key = 'comment_id',
    incremental_strategy = 'merge',
    )
}}
select 
  comment_id,
  airport_ident,
  comment_timestamp,
  coalesce(member_nickname,'__UNKNOWN__') as member_nickname,
  comment_subject,
  comment_body,
  current_timestamp() as loaded_at
from {{ ref('stg_airport_comments') }}
WHERE NULLIF(TRIM(comment_body), '') IS NOT NULL

{% if is_incremental() %}
  and comment_id >= (select max(comment_id) from {{ this }})
{% endif %}