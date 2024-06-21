{% macro postgres__hash_alg_md5() -%}

    {% do return("MD5([HASH_STRING_PLACEHOLDER])") %}

{% endmacro %}