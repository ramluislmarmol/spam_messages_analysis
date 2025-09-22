CREATE OR REPLACE VIEW date_data AS 
SELECT
	id,
    HOUR(date) AS hour,
    CONCAT(HOUR(date), ":00") AS hour_str
FROM spam_messages;