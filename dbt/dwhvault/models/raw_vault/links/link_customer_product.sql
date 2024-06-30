{{
    config(
        schema='raw_vault',
        materialized='incremental',
        incremental_strategy='snapshot_link',
        unique_key='ordernumber_pk'
    )
}}


{%- set source_model = "order_stage_vault" -%}
{%- set src_pk = "ordernumber_pk" -%}
{%- set src_fk = ["usernumber_pk", "productnumber_pk"] -%}
{%- set src_ldts = "date_from" -%}
{%- set src_source = "source_sys" -%}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk,
                    src_extra_columns=src_extra_columns,
                    src_ldts=src_ldts, src_source=src_source,
                    source_model=source_model)}}

                