{{
    config(
        schema='raw_vault',
        materialized='incremental',
        unique_key='usernumber_pk',
        incremental_strategy='snapshot_sat',
        hash_diff='user_hashdiff'
    )
}}


{%- set source_model = "customer_stage_vault" -%}
{%- set src_pk = "usernumber_pk" -%}
{%- set src_hashdiff = "user_hashdiff" -%}
{%- set src_payload = ["user_number", "user_name", "user_email", "user_phone_number", "date_login"] -%}
{%- set src_eff = "date_from" -%}
{%- set src_ldts = "date_to" -%}
{%- set src_source = "source_sys" -%}


{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}