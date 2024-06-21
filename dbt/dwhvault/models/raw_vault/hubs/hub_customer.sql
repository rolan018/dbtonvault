{{
    config(
        schema="raw_vault",
        materialized="incremental",
        incremental_strategy='hub'
    )
}}


{%- set source_model = "customer_stage_vault" -%}
{%- set src_pk = "usernumber_pk" -%}
{%- set src_nk = "user_number" -%}
{%- set src_ldts_from = "date_from" -%}
{%- set src_source = "source_sys" -%}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts_from,
                src_source=src_source, source_model=source_model) }}