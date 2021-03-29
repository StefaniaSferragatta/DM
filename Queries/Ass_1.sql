# CREATE DATABASE onco_drug;
USE onco_drug;
#create a new table with the thresholds
CREATE TABLE thresholds (gene text(10), thsd double); 
INSERT INTO thresholds (
SELECT gene, AVG(fpkm) AS thsd FROM rna GROUP BY gene); 

SHOW TABLES;
SELECT * FROM tmp; #da cancellare??