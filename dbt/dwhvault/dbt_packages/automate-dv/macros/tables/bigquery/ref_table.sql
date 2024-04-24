/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro bigquery__ref_table(src_pk, src_extra_columns, src_ldts, src_source, source_model) -%}

{{- automate_dv.default__ref_table(src_pk=src_pk,
                                   src_extra_columns=src_extra_columns,
                                   src_ldts=src_ldts,
                                   src_source=src_source,
                                   source_model=source_model) -}}

{%- endmacro -%}
