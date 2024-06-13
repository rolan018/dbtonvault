/*
Полная дедупликация записей
*/


{{
    config(
        schema='stage_vault',
        materialized='table'
    )
}}

{%- set column_names = adapter.get_columns_in_relation(source('source', 'product')) -%}

with product_date_dedup as (
		select * from (
			select *,
				   row_number() 
				   over (partition by {{ column_names|map(attribute="name")|join(",") }}) as rn
			from {{ source('source', 'product') }} pa
			where date_load = '{{ var('source_date') }}'
		) as h
		where rn = 1
	)
select
{{ column_names|map(attribute="name")|join(",") }}
from product_date_dedup ra