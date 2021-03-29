# Given a sample ID, return a list of overexpressed gene and possible type of alterations

SELECT DISTINCT HUGO_GENE, ALTERATIONS
FROM ONCOKB_DRUG
WHERE HUGO_GENE IN (
SELECT HUGO_GENE
FROM CONVERTER 
WHERE EXISTS ( # "The EXISTS operator checks if the row FROM the subquery matches any row in the outer query"
SELECT RNA.GENE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE = TH.GENE
WHERE RNA.FPKM>TH.THSD AND RNA.SAMPLE = 'TCGA-2F-A9KO-01A'));