{% macro postgres__log_relation_sources(relation, source_count) %}

    {%- if execute -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}.{}".format(relation.database, relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}