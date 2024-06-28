/*
* Macros for incremental for Postgres Adapter
*/


{% macro postgres_validate_incremental_strategy(config) %}
  {#-- Find and validate the incremental strategy #}
  {%- set strategy = config.get("incremental_strategy", default="merge") -%}

  {% set invalid_strategy_msg -%}
    Invalid incremental strategy provided: {{ strategy }}
    Expected one of: 'snapshot_sat', 'snapshot_hub'
  {%- endset %}
  {% if strategy not in ['snapshot_sat', 'snapshot_hub'] %}
    {% do exceptions.raise_compiler_error(invalid_strategy_msg) %}
  {% endif %}

  {% do return(strategy) %}
{% endmacro %}

{% macro postgres_get_incremental_sql(strategy, tmp_relation, target_relation, unique_key, hash_diff, dest_columns) %}
  {% if strategy == 'snapshot_sat' %}
    {% if unique_key == '' or hash_diff == '' %}
      {% do exceptions.raise_compiler_error("With incremental_strategy=\'snapshot_sat\' unique_key and hash_diff must be specified") %}
    {% endif %}
    {% do return(postgres_snapshot_sat_merge_sql(target_relation, tmp_relation, unique_key, hash_diff, dest_columns)) %}
  {% elif strategy == 'snapshot_hub' %}
    {% if unique_key == '' %}
      {% do exceptions.raise_compiler_error("With incremental_strategy=\'snapshot_hub\' unique_key must be specified") %}
    {% endif %}
    {% do return(postgres_snapshot_hub_merge_sql(target_relation, tmp_relation, unique_key, dest_columns)) %}
  {% else %}
    {% do exceptions.raise_compiler_error('invalid strategy: ' ~ strategy) %}
  {% endif %}
{% endmacro %}

{% materialization incremental, adapter='postgres' -%}

  {%- set unique_key = config.get('unique_key', '') -%}
  {%- set hash_diff = config.get('hash_diff', '') -%}

  {%- set full_refresh_mode = (should_full_refresh()) -%}

  {% set target_relation = this %}
  {% set existing_relation = load_relation(this) %}
  {% set tmp_relation = make_temp_relation(this) %}

  {#-- Validate early so we don't run SQL if the strategy is invalid --#}
  {% set strategy = postgres_validate_incremental_strategy(config) -%}
  {% set on_schema_change = incremental_validate_on_schema_change(config.get('on_schema_change'), default='ignore') %}

  {{ run_hooks(pre_hooks) }}

  {% if existing_relation is none %}
    {% set build_sql = create_table_as(False, target_relation, sql) %}
  
  {% elif existing_relation.is_view %}
    {#-- Can't overwrite a view with a table - we must drop --#}
    {{ log("Dropping relation " ~ target_relation ~ " because it is a view and this model is a table.") }}
    {% do adapter.drop_relation(existing_relation) %}
    {% set build_sql = create_table_as(False, target_relation, sql) %}
  
  {% elif full_refresh_mode %}
    {% set build_sql = create_table_as(False, target_relation, sql) %}
  
  {% else %}
    {% do run_query(create_table_as(True, tmp_relation, sql)) %}
    {% do adapter.expand_target_column_types(
           from_relation=tmp_relation,
           to_relation=target_relation) %}
    {#-- Process schema changes. Returns dict of changes if successful. Use source columns for upserting/merging --#}
    {% set dest_columns = process_schema_changes(on_schema_change, tmp_relation, existing_relation) %}
    {% if not dest_columns %}
      {% set dest_columns = adapter.get_columns_in_relation(existing_relation) %}
    {% endif %}
    {% set build_sql = postgres_get_incremental_sql(strategy, tmp_relation, target_relation, unique_key, hash_diff, dest_columns) %}
  
  {% endif %}

  {%- call statement('main') -%}
    {{ build_sql }}
  {%- endcall -%}

  -- `COMMIT` happens here
  {% do adapter.commit() %}

  {{ run_hooks(post_hooks) }}

  {% set target_relation = target_relation.incorporate(type='table') %}
  {% do persist_docs(target_relation, model) %}

  {{ return({'relations': [target_relation]}) }}

{%- endmaterialization %}