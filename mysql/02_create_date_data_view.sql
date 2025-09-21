CREATE OR REPLACE VIEW date_data AS 
SELECT
	hashed_cellphone_number,
	YEAR(date) AS year,
    MONTH(date) AS month,
    DAY(date) AS day,
    HOUR(date) AS hour
FROM spam_messages;