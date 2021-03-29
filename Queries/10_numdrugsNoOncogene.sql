# Show the gene whose number of drugs associated is more than 2 but are not oncogene

SELECT HUGO_GENE
FROM oncokb_drug join onco_genes using (hugo_gene)
WHERE isoncogene = 'no'
GROUP BY HUGO_GENE
HAVING COUNT(DRUGS) > 2
ORDER BY COUNT(DRUGS) desc;