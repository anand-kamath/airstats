
{{
  config(
    materialized = 'ephemeral',
    )
}}
with sources as 
(select * from {{ source('raw', 'airport_comments') }}
)
select 
  id as comment_id,
  airport_ident,
  date as comment_timestamp,
  member_nickname,
  subject as comment_subject,
  body as comment_body
from sources