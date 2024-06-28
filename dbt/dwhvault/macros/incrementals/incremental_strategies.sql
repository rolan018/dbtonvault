{% macro postgres_snapshot_hub_merge_sql(target, source, unique_key, dest_columns) -%}

    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute="name")) -%}

    merge into {{ target }} as t
    using {{ source }} as s
    on s.{{ unique_key }} = t.{{ unique_key }} 
    when matched then
    update set date_to = s.date_to, is_active = s.is_active, date_from = s.date_from
    when not matched then
        insert ({{ dest_cols_csv }})
        values (s.{{ dest_columns|map(attribute="name")|join(', s.') }});

{%- endmacro %}

{% macro postgres_snapshot_sat_merge_sql(target, source, unique_key, hash_diff, dest_columns) -%}

    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute="name")) -%}

    merge into {{ target }} as t
    using {{ source }} as s
    on s.{{ unique_key }} = t.{{ unique_key }} and s.{{ hash_diff }} = t.{{ hash_diff }} and t.is_active = True
    when matched then
        update set 
        date_to = s.date_to, 
        is_active = s.is_active,
        operation_vault = s.operation_vault
    when not matched and s.operation_vault in ('I', 'U') then
        insert ({{ dest_cols_csv }})
        values (s.{{ dest_columns|map(attribute="name")|join(', s.') }});

{% endmacro %}

{% macro postgres_merge_sql(target, source, dest_columns, predicates, include_sql_header) -%}
    {%- set predicates = [] if predicates is none else [] + predicates -%}
    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute="name")) -%}
    {%- set sql_header = config.get('sql_header', none) -%}

    {{ sql_header if sql_header is not none and include_sql_header }}

    merge into {{ target }} as DBT_INTERNAL_DEST
        using {{ source }} as DBT_INTERNAL_SOURCE
        on FALSE

    when not matched by source
        {% if predicates %} and {{ predicates | join(' and ') }} {% endif %}
        then delete

    when not matched then insert
        ({{ dest_cols_csv }})
    values
        ({{ dest_cols_csv }})

{% endmacro %}