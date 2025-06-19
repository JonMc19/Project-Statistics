CREATE DATABASE Project_Statistics;
USE Project_Statistics;

CREATE TABLE df_cleaned_merged_web_data (
    client_id INT NOT NULL,
    visitor_id VARCHAR(50) NOT NULL,
    visit_id VARCHAR(100) NOT NULL,
    process_step VARCHAR(20),
    date_time DATETIME,
    PRIMARY KEY (client_id, visitor_id, visit_id, date_time)
);


CREATE TABLE df_final_demo_cleaned (
    client_id INT PRIMARY KEY,
    client_tenure_year TINYINT,
    client_tenure_month SMALLINT,
    client_age DECIMAL(4,1),
    gender ENUM('M', 'F'),
    number_of_accounts_ TINYINT,
    balance DECIMAL(12,2),
    calls_past_6_months TINYINT,
    logins_last_6_months TINYINT
);


CREATE TABLE df_experiment_clients_cleaned (
    client_id INT PRIMARY KEY,
    Variation VARCHAR(20)
);

