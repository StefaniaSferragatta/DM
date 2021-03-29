#Show the number of sample for cancer type that pass the thsd and have a given associated drug
SELECT RNA.CANCER, COUNT(DISTINCT RNA.SAMPLE) as NUM_SAMPLE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE=TH.GENE 
WHERE RNA.FPKM>TH.THSD 
AND (RNA.GENE) IN (
SELECT EnsemblgeneID 
FROM CONVERTER 
WHERE EXISTS (
SELECT HUGO_GENE FROM ONCOKB_DRUG WHERE DRUGS='Afatinib'))
GROUP BY RNA.CANCER;

# SHOW THE SAMPLE THAT PASS THE THRESHOLD AND have a given associated drug
SELECT RNA.SAMPLE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE=TH.GENE 
WHERE RNA.FPKM>TH.THSD 
AND (RNA.GENE) IN (
SELECT EnsemblgeneID 
FROM CONVERTER 
WHERE EXISTS (
SELECT HUGO_GENE FROM ONCOKB_DRUG WHERE DRUGS LIKE 'Afatinib'));


#####################################
SELECT Distinct DRUGS FROM oncokb_drug ORDER BY DRUGS;
