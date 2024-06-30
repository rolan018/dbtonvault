/*
 * Changed macros from AutomateDV
 */

{%- macro postgres__link(src_pk, src_fk, src_extra_columns, src_ldts, src_source, source_model) -%}

{#- valid to and valid from dates -#}
{%- set src_ldts_from = src_ldts -%}
{%- set src_ldts_to = "date_to" -%}

{%- set cols_without_ldts_to = automate_dv.expand_column_list(columns=[src_pk, src_fk, src_extra_columns, src_source, src_ldts_from]) -%}
{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_fk, src_extra_columns, src_source, src_ldts_from, src_ldts_to]) -%}

{%- set fk_cols = automate_dv.expand_column_list([src_fk]) -%}

{{ 'WITH ' -}}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif -%}

{%- set ns = namespace(last_cte= "") -%}

{%- for src in source_model -%}

{%- set source_number = loop.index | string -%}

row_rank_{{ source_number }} AS (
    SELECT {{ automate_dv.prefix(source_cols, 'rr') }}
    FROM {{ ref(src) }} AS rr
    {%- if source_model | length == 1 %}
    WHERE {{ automate_dv.multikey(src_pk, prefix='rr', condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(fk_cols, prefix='rr', condition='IS NOT NULL') }}
    {%- endif %}
    {%- set ns.last_cte = "row_rank_{}".format(source_number) %}
),{{ "\n" if not loop.last }}
{% endfor -%}
{%- if source_model | length > 1 %}
stage_union AS (
    {%- for src in source_model %}
    SELECT * FROM row_rank_{{ loop.index | string }}
    {%- if not loop.last %}
    UNION ALL
    {%- endif %}
    {%- endfor %}
    {%- set ns.last_cte = "stage_union" %}
),
row_rank_union AS (
  SELECT * FROM (
    SELECT ru.*,
           ROW_NUMBER() OVER(
               PARTITION BY {{ automate_dv.prefix([src_pk], 'ru') }}
               ORDER BY {{ automate_dv.prefix([src_ldts], 'ru') }}, {{ automate_dv.prefix([src_source], 'ru') }} ASC
           ) AS row_rank_number
    FROM {{ ns.last_cte }} AS ru
    WHERE {{ automate_dv.multikey(src_pk, prefix='ru', condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(fk_cols, prefix='ru', condition='IS NOT NULL') }}
  ) AS a
  WHERE row_rank_number = 1
    {%- set ns.last_cte = "row_rank_union" %}
),
{%- endif %}
{%- if automate_dv.is_any_incremental() %}
active_link AS (
    SELECT * 
    FROM {{ this }}
    WHERE is_active=True
), 
records_to_delete AS (
    SELECT {{ automate_dv.prefix(cols_without_ldts_to, 'd', alias_target='target') }}, now()::date, False as is_active
    FROM {{ ns.last_cte }} AS a
    RIGHT JOIN active_link AS d
    ON {{ automate_dv.multikey(src_pk, prefix=['a','d'], condition='=') }}
    WHERE {{ automate_dv.multikey(src_pk, prefix='a', condition='IS NULL') }}
),
{%- endif %}
records_to_insert AS (
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='target') }}, True as is_active
    FROM {{ ns.last_cte }} AS a
    {%- if automate_dv.is_any_incremental() %}
    LEFT JOIN active_link AS d
    ON {{ automate_dv.multikey(src_pk, prefix=['a','d'], condition='=') }}
    WHERE {{ automate_dv.multikey(src_pk, prefix='d', condition='IS NULL') }}
    {%- endif %}
)
SELECT * FROM records_to_insert
{%- if automate_dv.is_any_incremental() %}
UNION 
SELECT * FROM records_to_delete
{%- endif %}
{%- endmacro -%}