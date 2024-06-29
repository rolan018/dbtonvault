/*
 * Changed macros from AutomateDV
 */

{%- macro postgres__sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_extra_columns, src_source, src_eff, src_ldts]) -%}
{%- set source_cols_without_ldts = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_extra_columns, src_source, src_eff]) -%}
{%- set window_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}

{%- set pk_cols = automate_dv.expand_column_list(columns=[src_pk]) -%}
{%- set valid_from = automate_dv.expand_column_list(columns=[src_eff]) -%}
{%- set valid_to = automate_dv.expand_column_list(columns=[src_ldts]) -%}

WITH source_data AS (
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ automate_dv.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
),

{%- if automate_dv.is_any_incremental() %}

latest_records AS (
    SELECT {{ automate_dv.prefix(source_cols, 'current_records', alias_target='target') }}, is_active
    FROM {{ this }} AS current_records
    WHERE is_active = True
),
records_to_update AS (
    SELECT {{ automate_dv.alias_all(source_cols, 'sd') }},'U' as operation_vault, True as is_active
    FROM source_data AS sd
        JOIN latest_records AS lr
            ON {{ automate_dv.multikey(src_pk, prefix=['lr','sd'], condition='=') }}
            AND {{ automate_dv.prefix([src_hashdiff], 'lr', alias_target='target') }} <> {{ automate_dv.prefix([src_hashdiff], 'sd') }}
),
records_to_reupdate AS (
    SELECT {{ automate_dv.alias_all(source_cols_without_ldts, 'lr') }}, now()::date,'U' as operation_vault, False as is_active
    FROM source_data AS sd
        JOIN latest_records AS lr
            ON {{ automate_dv.multikey(src_pk, prefix=['lr','sd'], condition='=') }}
            AND {{ automate_dv.prefix([src_hashdiff], 'lr', alias_target='target') }} <> {{ automate_dv.prefix([src_hashdiff], 'sd') }}
),
records_to_delete AS (
    SELECT {{ automate_dv.alias_all(source_cols_without_ldts, 'lr') }}, now()::date, 'D' as operation_vault, False as is_active
        FROM source_data AS sd
        RIGHT JOIN latest_records AS lr
            ON {{ automate_dv.multikey(src_pk, prefix=['lr','sd'], condition='=') }}
            WHERE {{ automate_dv.prefix([src_hashdiff], 'sd', alias_target='target') }} IS NULL
),

{%- endif %}
records_to_insert AS (
        SELECT {{ automate_dv.alias_all(source_cols, 'sd') }},'I' as operation_vault, True as is_active
        FROM source_data AS sd
        {%- if automate_dv.is_any_incremental() %}
        LEFT JOIN latest_records AS lr
            ON {{ automate_dv.multikey(src_pk, prefix=['lr','sd'], condition='=') }}
            WHERE {{ automate_dv.prefix([src_hashdiff], 'lr', alias_target='target') }} IS NULL
        {%- endif %}
)
SELECT * FROM records_to_insert
{% if automate_dv.is_any_incremental() -%}

UNION
SELECT * FROM records_to_delete
UNION
SELECT * FROM records_to_update
UNION
SELECT * FROM records_to_reupdate

{% endif -%}
{%- endmacro -%}
