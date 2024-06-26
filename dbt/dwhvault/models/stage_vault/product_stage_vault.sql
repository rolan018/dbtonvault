{{
    config(
        schema='stage_vault',
        materialized='table',
    )
}}


{%- set yaml_metadata -%}
source_model: 'product_stage'
derived_columns:
  DATE_FROM: DATE_LOAD
  DATE_TO: "TO_DATE('2100-01-01', 'YYYY-MM-DD')"
  SOURCE_SYS: '!AMO'
hashed_columns:
  PRODUCTNUMBER_PK:
    - PRODUCT_NUMBER
  PRODUCT_HASHDIFF:
    is_hashdiff: true
    columns:
      - PRODUCT_NAME
      - FUEL_TYPE
      - GEAR_TYPE
      - PRODUCT_CATEGORY
      - DATE_PRODUCT
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