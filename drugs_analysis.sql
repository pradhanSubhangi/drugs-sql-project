SET GLOBAL local_infile = 1;
USE drugs_project;
DROP TABLE IF EXISTS drugs_project;
DROP TABLE IF EXISTS drugs;

CREATE TABLE drugs (
    drug_name VARCHAR(255),
    medical_condition VARCHAR(255),
    side_effects TEXT,
    generic_name VARCHAR(255),
    drug_classes VARCHAR(500),
    brand_names VARCHAR(500),
    activity VARCHAR(20),
    rx_otc VARCHAR(20),
    pregnancy_category VARCHAR(10),
    csa VARCHAR(10),
    alcohol VARCHAR(10),
    related_drugs TEXT,
    medical_condition_description TEXT,
    rating FLOAT,
    no_of_reviews FLOAT,
    drug_link VARCHAR(500),
    medical_condition_url VARCHAR(500)
);
USE drugs_project;
DROP TABLE drugs;
DROP TABLE IF EXISTS drugs_project;
CREATE TABLE drugs (
    drug_name VARCHAR(255),
    medical_condition VARCHAR(255),
    side_effects TEXT,
    generic_name VARCHAR(255),
    drug_classes VARCHAR(500),
    brand_names VARCHAR(500),
    activity VARCHAR(20),
    rx_otc VARCHAR(20),
    pregnancy_category VARCHAR(10),
    csa VARCHAR(10),
    alcohol VARCHAR(10),
    related_drugs TEXT,
    medical_condition_description TEXT,
    rating FLOAT,
    no_of_reviews FLOAT,
    drug_link VARCHAR(500),
    medical_condition_url VARCHAR(500)
);
SELECT COUNT(*) FROM drugs;
LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/drugs-sql-project/drugs_side_effects_drugs_com.csv'
INTO TABLE drugs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(drug_name, medical_condition, side_effects, generic_name,
 drug_classes, brand_names, activity, rx_otc, pregnancy_category,
 csa, alcohol, related_drugs, medical_condition_description,
 rating, no_of_reviews, drug_link, medical_condition_url);
 SELECT COUNT(*) AS total_rows FROM drugs;
 USE drugs_project;
SET SQL_SAFE_UPDATES = 0;

-- Fix missing values
UPDATE drugs SET side_effects = 'Unknown' WHERE side_effects IS NULL OR side_effects = '';
UPDATE drugs SET generic_name = 'Unknown' WHERE generic_name IS NULL OR generic_name = '';
UPDATE drugs SET drug_classes = 'Unknown' WHERE drug_classes IS NULL OR drug_classes = '';
UPDATE drugs SET rating = 0 WHERE rating IS NULL;
UPDATE drugs SET no_of_reviews = 0 WHERE no_of_reviews IS NULL;
UPDATE drugs SET alcohol = 'No Interaction' WHERE alcohol IS NULL OR alcohol = '';
UPDATE drugs SET alcohol = 'Interacts' WHERE alcohol = 'X';
UPDATE drugs SET rx_otc = 'Unknown' WHERE rx_otc IS NULL OR rx_otc = '';
UPDATE drugs SET pregnancy_category = 'Unknown' WHERE pregnancy_category IS NULL OR pregnancy_category = '';

SET SQL_SAFE_UPDATES = 1;
-- 1. Total rows
SELECT COUNT(*) AS total_rows FROM drugs;

-- 2. Top 10 medical conditions
SELECT medical_condition, COUNT(*) AS number_of_drugs
FROM drugs
GROUP BY medical_condition
ORDER BY number_of_drugs DESC
LIMIT 10;

-- 3. Top 10 highest rated drugs
SELECT drug_name, medical_condition, rating, no_of_reviews
FROM drugs
WHERE rating > 0
ORDER BY rating DESC
LIMIT 10;

-- 4. Average rating per condition
SELECT medical_condition, ROUND(AVG(rating), 2) AS avg_rating, COUNT(*) AS total_drugs
FROM drugs
WHERE rating > 0
GROUP BY medical_condition
ORDER BY avg_rating DESC;

-- 5. Rx vs OTC breakdown
SELECT rx_otc, COUNT(*) AS total_drugs
FROM drugs
GROUP BY rx_otc
ORDER BY total_drugs DESC;

-- 6. Alcohol interaction
SELECT alcohol, COUNT(*) AS total_drugs
FROM drugs
GROUP BY alcohol;

-- 7. Pregnancy category breakdown
SELECT pregnancy_category, COUNT(*) AS total_drugs
FROM drugs
GROUP BY pregnancy_category
ORDER BY total_drugs DESC;

-- 8. Most popular drug classes
SELECT drug_classes, COUNT(*) AS total_drugs
FROM drugs
WHERE drug_classes != 'Unknown'
GROUP BY drug_classes
ORDER BY total_drugs DESC
LIMIT 10;

-- 9. Most reviewed drugs
SELECT drug_name, medical_condition, rating, no_of_reviews
FROM drugs
WHERE no_of_reviews > 0
ORDER BY no_of_reviews DESC
LIMIT 10;