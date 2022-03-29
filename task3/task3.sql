select project_id, customer_id, create_dte as "event_datetime"
from (
	select
	properties.project_id
	, properties_values.customer_id
	, properties.label
	, properties_values.value
	, properties_values.create_dte
	,CASE WHEN
	lower(
	LAG (properties_values.value,1) OVER (PARTITION BY properties.project_id,
	properties_values.customer_id, properties.label
	ORDER BY properties_values.create_dte ASC)
	) = 'yes' and lower(properties_values.value)='no'
	then 1 else 0 end as "flag"
	from properties_values
	join properties on properties.id=properties_values.property_id
	where
	lower(properties.label) = 'marketing_consent'
	order by properties.project_id , properties_values.customer_id
	) change_flag
	where flag = 1
	;