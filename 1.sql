# From drug to sample ID (Onco drug → Converter → RNA)
# 1. Scegli una drug → Lista di geni 
# 2. Lista di geni in Hugo → Lista di geni in ensembl
# 3. Lista di geni in ensembl → Lista di samples id  (if fpkm > threshold)

SELECT RNA.SAMPLE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE=TH.GENE 
WHERE RNA.FPKM>TH.THSD 
AND (RNA.GENE) IN (
SELECT EnsemblgeneID 
FROM CONVERTER 
WHERE (HUGO_GENE) IN (
SELECT HUGO_GENE FROM ONCOKB_DRUG WHERE DRUGS LIKE 'OLAPARIB'));


