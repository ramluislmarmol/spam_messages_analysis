CREATE OR REPLACE VIEW text_data AS
WITH cte AS (
    SELECT
        hashed_cellphone_number,
        COALESCE(TRIM(text), '') AS text,
        REGEXP_REPLACE(COALESCE(TRIM(text), ''), '[[:space:]]', '') AS no_space_text,
        REGEXP_REPLACE(COALESCE(TRIM(text), ''), '[A-Z]', '', 1, 0, 'c') AS no_upper_text,
        REGEXP_REPLACE(COALESCE(TRIM(text), ''), '[[:digit:]]', '') AS no_digit_text,
        REGEXP_REPLACE(COALESCE(TRIM(text), ''), '[[:punct:]]', '') AS no_punc_text,
        REGEXP_REPLACE(COALESCE(TRIM(text), ''), '[^[:alnum:]]', '') AS alnum_text
    FROM spam_messages
)
SELECT
    hashed_cellphone_number,
    CHAR_LENGTH(text) AS char_length,
    CASE 
        WHEN CHAR_LENGTH(text) = 0 THEN 0 
        ELSE CHAR_LENGTH(text) - CHAR_LENGTH(no_space_text) + 1 
    END AS word_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_upper_text) AS uppercase_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_digit_text) AS digit_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_punc_text) AS punctuation_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(alnum_text) AS non_alnum_count,
    REGEXP_LIKE(text, 'http|www|com|bit') AS has_url,
    REGEXP_LIKE(text, 'free|win|urgent|limited|offer|deal|prize|discount') AS has_spam_keywords,
    REGEXP_LIKE(text, 'money|cash|payment|credit|bank|account|deposit') AS has_financial_keywords,
    REGEXP_LIKE(text, 'click|call[[:space:]]*now|subscribe|buy[[:space:]]*now|sign[[:space:]]*up') AS has_action_keywords,
    REGEXP_LIKE(text, 'verify|account|password|login|personal|security') AS has_info_keywords
FROM cte;