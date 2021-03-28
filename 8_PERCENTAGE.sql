# Find the percentage of genes that are overexpressed given a cancer type and pass the oncogene filter
#CREATE A VIEW TO COMPUTE THE AVG OF FPKM OF THE BLCA CANCER TYPE
CREATE VIEW FPKM_BLCA (GENE,AVG_FPKM) AS
SELECT GENE,AVG(RNA.FPKM) AS AVG_FPKM FROM RNA AS RNA where rna.Cancer = 'BLCA' GROUP BY RNA.GENE;

SELECT (
SELECT COUNT(DISTINCT TH.GENE)
FROM THRESHOLDS AS TH JOIN FPKM_BLCA AS FPKM_BLCA ON TH.GENE=FPKM_BLCA.GENE
WHERE TH.thsd<FPKM_BLCA.AVG_FPKM
AND (TH.GENE) IN (
SELECT ENSEMBLGENEID 
FROM CONVERTER
WHERE HUGO_GENE IN (
SELECT HUGO_GENE FROM ONCO_GENES WHERE ISONCOGENE = 'YES')))
/ (SELECT COUNT(*) FROM THRESHOLDS) * 100 AS PERCENTAGE;