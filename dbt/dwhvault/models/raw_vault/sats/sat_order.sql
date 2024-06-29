{{
    config(
        schema='raw_vault',
        materialized='incremental',
        incremental_strategy='snapshot_sat',
        unique_key='ordernumber_pk',
        hash_diff='order_hashdiff'
    )
}}


{%- set source_model = "customer_stage_vault" -%}
{%- set src_pk = "ordernumber_pk" -%}
{%- set src_hashdiff = "order_hashdiff" -%}
{%- set src_payload = ["order_description", "date_order"] -%}
{%- set src_eff = "date_from" -%}
{%- set src_ldts = "date_to" -%}
{%- set src_source = "source_sys" -%}


{{ automate_dv.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}