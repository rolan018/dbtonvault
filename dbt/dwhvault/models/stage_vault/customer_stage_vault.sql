{{
    config(
        schema='stage_vault',
        materialized='table',
    )
}}


{%- set yaml_metadata -%}
source_model: 'customer_stage'
derived_columns:
  DATE_FROM: DATE_LOAD
  DATE_TO: "TO_DATE('2100-01-01', 'YYYY-MM-DD')"
  SOURCE_SYS: '!AMO'
hashed_columns:
  USERNUMBER_PK:
    - USER_NUMBER
  USER_HASHDIFF:
    is_hashdiff: true
    columns:
      - USER_NAME
      - USER_EMAIL
      - USER_PHONE_NUMBER
      - DATE_LOGIN
{%- endset -%}


{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}