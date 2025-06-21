use Project_Statistics;

What was the issue?

You created three tables in a MySQL database and expected them to be connected in an EER diagram. However, they weren’t connected because there were no foreign key constraints defined between the tables.
/*
✅ What we did to fix it

1. Identified the relationship
All three tables shared a client_id column.
So, we decided to connect them using foreign keys, which tell the database how tables are related.
Specifically, we said:
"client_id in df_cleaned_merged_web_data should reference client_id in df_final_demo_cleaned."
2. Tried to add the foreign key
But when we tried, we got an error:

Error 1452: Cannot add or update a child row — a foreign key constraint fails.
This means that df_cleaned_merged_web_data had some client_ids that did not exist in the df_final_demo_cleaned table — which breaks the rule of foreign keys.

3. Chose a fix (Option A)
You chose to add the missing client IDs to the parent table (df_final_demo_cleaned), inserting them along with NULL values for the other fields.

*/

#This query provides the ids that were missing

SELECT DISTINCT client_id
FROM df_cleaned_merged_web_data
WHERE client_id NOT IN (
    SELECT client_id FROM df_final_demo_cleaned
);

#Using the following query:
#This added all the missing client_ids to the table, allowing the foreign key to be created successfully.


INSERT INTO df_final_demo_cleaned (
    client_id,
    client_tenure_year,
    client_tenure_month,
    client_age,
    gender,
    number_of_accounts_,
    balance,
    calls_past_6_months,
    logins_last_6_months
)
SELECT DISTINCT client_id,
       NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
FROM df_cleaned_merged_web_data
WHERE client_id NOT IN (
    SELECT client_id FROM df_final_demo_cleaned
);

#4. Added the foreign key constraint
#Finally, we ran:

ALTER TABLE df_cleaned_merged_web_data
ADD CONSTRAINT fk_client_demo
FOREIGN KEY (client_id)
REFERENCES df_final_demo_cleaned(client_id);

ALTER TABLE df_experiment_clients_cleaned
ADD CONSTRAINT fk_client_demo_experiment
FOREIGN KEY (client_id)
REFERENCES df_final_demo_cleaned(client_id);

