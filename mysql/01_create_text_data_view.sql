CREATE OR REPLACE VIEW text_data AS
WITH cte1 AS (
	SELECT 
		id, TRIM(text) AS text,
		REGEXP_REPLACE(text, '[[:space:]]', '') AS no_space_text,
		REGEXP_REPLACE(text, '[[:upper:]]', '', 1, 0, 'c') AS no_upper_text,
		REGEXP_REPLACE(text, '[[:digit:]]', '') AS no_digit_text,
		REGEXP_REPLACE(text, '[[:punct:]]', '') AS no_punc_text,
		REGEXP_REPLACE(text, '[^[:alnum:]]', '') AS alnum_text
    FROM spam_messages
), cte2 AS (
    SELECT
		id,
		CHAR_LENGTH(text) AS char_length,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_space_text) + 1 AS word_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_upper_text) AS uppercase_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_digit_text) AS digit_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_punc_text) AS punctuation_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(alnum_text) AS non_alnum_count,
		CASE WHEN REGEXP_LIKE(text, 'http|www.|.com|bit.|.site', 'i') THEN TRUE
			 ELSE FALSE END AS has_url
    FROM cte1
), cte3 AS (
	SELECT 
		*,
		uppercase_count / char_length AS uppercase_perc,
        digit_count / char_length AS digit_perc,
        punctuation_count / char_length AS punctuation_perc,
        non_alnum_count / char_length AS non_alnum_perc
	FROM cte2
)

SELECT * FROM cte3;
