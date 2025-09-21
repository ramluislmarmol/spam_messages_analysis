CREATE OR REPLACE VIEW text_data AS
WITH cte1 AS (
	SELECT
		hashed_cellphone_number,
		TRIM(text) AS text
	FROM spam_messages 
), cte2 AS (
	SELECT
		hashed_cellphone_number, text,
		REGEXP_REPLACE(text, '[[:space:]]', '') AS no_space_text,
		REGEXP_REPLACE(text, '[A-Z]', '', 1, 0 ,'c') AS no_upper_text,
        REGEXP_REPLACE(text, '[[:digit:]]', '') AS no_digit_text,
		REGEXP_REPLACE(text, '[[:punct:]]', '') AS no_punc_text,
		REGEXP_REPLACE(text, '[^[:alnum:]]', '') AS alnum_text
	FROM cte1
)

SELECT
    hashed_cellphone_number,
    CHAR_LENGTH(text) AS char_length,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_space_text) + 1 AS word_count,
    (text LIKE '%http://%' OR text LIKE '%https://%' OR text LIKE '%.com%') AS has_url,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_upper_text) AS uppercase_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_digit_text) AS digit_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_punc_text) AS punctuation_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(alnum_text) AS non_alnum_count
FROM cte2;