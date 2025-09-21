CREATE DATABASE IF NOT EXISTS spam_messages_analysis;
USE spam_messages_analysis;

CREATE TABLE IF NOT EXISTS spam_messages (
	masked_cellphone_number VARCHAR(255),
    hashed_cellphone_number CHAR(36),
    date DATETIME(3),
    text TEXT,
    carrier VARCHAR(50)
);

LOAD DATA LOCAL INFILE '<insert path here>'
INTO TABLE spam_messages
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(masked_cellphone_number,
 hashed_cellphone_number,
 date,
 text,
 carrier);
