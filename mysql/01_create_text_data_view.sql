CREATE OR REPLACE VIEW text_data AS
WITH trimmed AS (
	SELECT id, TRIM(text) AS text
    FROM spam_messages
), regexp_ AS (
    SELECT
		id, text,
        REGEXP_REPLACE(text, '[[:space:]]', '') AS no_space_text,
        REGEXP_REPLACE(text, '[A-Z]', '') AS no_upper_text,
        REGEXP_REPLACE(text, '[[:digit:]]', '') AS no_digit_text,
        REGEXP_REPLACE(text, '[[:punct:]]', '') AS no_punc_text,
        REGEXP_REPLACE(text, '[^[:alnum:]]', '') AS alnum_text,
		REGEXP_LIKE(text, 'http|www.|.com|bit.|.site', 'i') AS has_url,
		REGEXP_LIKE(text, 'free|win|award|reward|claim|urgent|limited|offer|deal|prize|discount', 'i') AS has_spam_keywords,
		REGEXP_LIKE(text, 'money|cash|payment|credit|bank|account|deposit|php', 'i') AS has_financial_keywords,
		REGEXP_LIKE(text, 'sale|exclusive|special|bonus|save|get|shop|promo|venue', 'i') AS has_promotional_keywords,
		REGEXP_LIKE(text, 'verify|account|password|login|personal|security', 'i') AS has_info_keywords
    FROM trimmed
), char_length AS (
	SELECT
		id,
		CHAR_LENGTH(text) AS char_length,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_space_text) + 1 AS word_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_upper_text) AS uppercase_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_digit_text) AS digit_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(no_punc_text) AS punctuation_count,
		CHAR_LENGTH(text) - CHAR_LENGTH(alnum_text) AS non_alnum_count
	FROM regexp_
), percs AS (
	SELECT 
		*,
		uppercase_count / char_length AS uppercase_perc,
        digit_count / char_length AS digit_perc,
        punctuation_count / char_length AS punctuation_perc,
        non_alnum_count / char_length AS non_alnum_perc
	FROM char_length
)

SELECT * FROM percs;
