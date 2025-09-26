# Project Description

## Rationale
This project aims on analyzing spam messages from various mobile carriers in the Philippines using an interactive dashboard. It uses MySQL for database management and Power BI for dynamic data visualization.

## Project Output
### Dashboard
![spam_messages_dashboard.gif](/powerbi/exports/spam_messages_dashboard.gif
) 
### Key Insights
- The average words per spam message received is 22.83 words, while the average characters is 135.89 characters.
- TNT, Smart and Smart/TNT has the most spam messages received.
- Out of the 1014 messages, 38% of which contains a link.
- Total messages per month peaks on February to May, with another sudden spike during the holidays.

## Tools and Methodology
### Power BI
Used Power BI to create visualizations and design a dashboard. Also utilized DAX Expressions to generate month and hour tables as x-axis for the line charts.
```
months = 
ADDCOLUMNS (
    GENERATESERIES ( 1, 12, 1 ),
    "MonthName", FORMAT ( DATE ( 2025, [Value], 1 ), "mmm" )
)
```
```
hours = 
ADDCOLUMNS (
    GENERATESERIES ( 0, 23, 1 ),
    "hour_str", FORMAT ( [Value], "00" ) & ":00"
)
```
### MySQL
Used MySQL for database management and data manipulation. Used the built-in `REGEXP` functions to analyze texts.
```
SELECT
    id,
    CHAR_LENGTH(text) AS char_length,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_space_text) + 1 AS word_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_upper_text) AS uppercase_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_digit_text) AS digit_count,
    CHAR_LENGTH(text) - CHAR_LENGTH(no_punc_text) AS punctuation_count,
    CHAR_LENGTH(no_space_text) - CHAR_LENGTH(alnum_text) AS non_alnum_count,
    CASE WHEN REGEXP_LIKE(text, 'http|www.|.com|bit.|.site', 'i') THEN TRUE
         ELSE FALSE END AS has_url
FROM cte1
```

## Learnings and Conclusion
Going into this project, I already had experience using Power BI and I wanted to both refine my querying skills and learn how to connect Power BI to a database server. Overall, this project enhanced my SQL client management skills as well as teaching me a few things about regular expressions.

## Installation
### Prerequisites
- [Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494)
- [MySQL](https://dev.mysql.com/downloads/installer/) (Optional, if you want to run the queries in [/mysql](/mysql))
### Setup
1. Open MySQL Workbench, go to your local instance.
2. Download the [raw data](/data/spam_messages.csv) and [sql queries](/mysql/).
3. Open MySQL Workbench, then open 00_setup_schema.sql. Replace "input file here" with the location of the downloaded spam_messages.csv.
4. Still within MySQL Workbench, run all the queries sequentially. This should create a database called spam_messages_analysis, a table called spam_messages, and two views called text_data, date_data.
4. Open Power BI and in "Get Data", connect using your MySQL local instance.