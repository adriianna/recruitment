CREATE TABLE properties (
  id SERIAL,
  project_id INT,
  "label" VARCHAR(255),
  PRIMARY KEY (id)
);

CREATE TABLE properties_values (
  id INT,
  customer_id INT,
  property_id INT,
  "value" VARCHAR(255),
  create_dte timestamp
);


COPY properties(id, project_id,"label")
--FROM '/var/lib/postgresql/data/project_properties.csv'
FROM '/var/lib/postgres/input_data/project_properties.csv'
DELIMITER ','
CSV HEADER;

COPY properties_values(id, customer_id,
					   property_id, "value", create_dte)
--FROM '/var/lib/postgresql/data/project_properties_values.csv'
FROM '/var/lib/postgres/input_data/project_properties_values.csv'
DELIMITER ','
CSV HEADER;

CREATE EXTENSION tablefunc;
--view

CREATE OR REPLACE VIEW marketing_program AS (
SELECT custom_id[1]::int as project_id, custom_id[2]::int as customer_id, plan, email , estimated_client_volume_usd , interested_in_product , avg_message_volume
FROM crosstab(
  $$
	WITH unified_labels as
	(
	--unified labels names, regex for email in email_contents
	select
	properties.project_id
	, properties_values.customer_id
	, case when properties.label = 'e-mail' or properties.label = 'email_contents'
	  then 'email'
	  else properties.label end "label"
	, case when properties.label = 'email_contents'
	  then substring(properties_values.value from '(?<=FROM:)(.*?)(?= CONTENTS)')
	  else properties_values.value end "value"
	, properties_values.create_dte
	from properties_values
	join properties on
	properties.id=properties_values.property_id
	where
	lower(properties.label) in ('plan','email','e-mail','estimated_client_volume_usd'
	,'interested_in_product','avg_message_volume','email_contents')
	),

	latest_values as (
	--get latest created values
	select customers_values.project_id,customers_values.customer_id,
	customers_values.label, customers_values.value
	from(
	select unified_labels.*,
	rank() OVER (PARTITION BY unified_labels.project_id, unified_labels.customer_id
				 , unified_labels.label
	ORDER BY unified_labels.create_dte DESC)
	AS "rank"
	from unified_labels) customers_values
	where customers_values.rank=1)

	SELECT ARRAY[project_id, customer_id]::text[], label, value FROM latest_values  ORDER BY 1,2,3 $$,
	$$ values ('plan'), ('email'), ('estimated_client_volume_usd'), ('interested_in_product'), ('avg_message_volume')$$
    ) AS t(custom_id text[], plan text, email text, estimated_client_volume_usd int, interested_in_product text, avg_message_volume int)
	WHERE avg_message_volume > 5000 and estimated_client_volume_usd>1000 and lower(plan) = 'free' and lower(interested_in_product)= 'yes'
	);