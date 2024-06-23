{{
    config(
        schema="raw_vault",
        materialized="incremental",
        incremental_strategy='hub',
        unique_key='productnumber_pk'
    )
}}


{%- set source_model = "product_stage_vault" -%}
{%- set src_pk = "productnumber_pk" -%}
{%- set src_nk = "product_number" -%}
{%- set src_ldts_from = "date_from" -%}
{%- set src_source = "source_sys" -%}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts_from,
                src_source=src_source, source_model=source_model) }}