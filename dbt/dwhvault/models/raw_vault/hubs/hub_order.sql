{{
    config(
        schema="raw_vault",
        materialized="incremental",
        incremental_strategy='snapshot_hub',
        unique_key='ordernumber_pk'
    )
}}


{%- set source_model = "order_stage_vault" -%}
{%- set src_pk = "ordernumber_pk" -%}
{%- set src_nk = "order_number" -%}
{%- set src_ldts_from = "date_from" -%}
{%- set src_source = "source_sys" -%}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts_from,
                src_source=src_source, source_model=source_model) }}