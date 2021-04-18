# CREATE DATABASE onco_drug;
USE onco_drug;
# TABLES
DESC converter;
select * from converter;

DESC onco_genes;
select * from onco_genes;

DESC oncokb_drug;
select * from oncokb_drug;

DESC RNA;
select * from rna;

#create a new table with the thresholds
CREATE TABLE thresholds (gene text(10), thsd double); 

INSERT INTO thresholds (
						SELECT gene, AVG(fpkm) AS thsd 
						FROM rna 
						GROUP BY gene); 

DESC thresholds;
select * from thresholds;

#QUERIES
#1.
# Show the number of sample for cancer type that pass the thsd and have the given associated drug
SELECT RNA.CANCER, COUNT(DISTINCT RNA.SAMPLE) as NUM_SAMPLE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE=TH.GENE 
WHERE RNA.FPKM>TH.THSD 
AND (RNA.GENE) IN (
	SELECT EnsemblgeneID 
	FROM CONVERTER 
	WHERE EXISTS (
		SELECT HUGO_GENE FROM ONCOKB_DRUG WHERE DRUGS='Afatinib'))
GROUP BY RNA.CANCER; 

#3.
# Find tumor suppressor genes that are overexpressed in at least 8 types of cancer
SELECT COUNT(DISTINCT RNA.CANCER) AS NUM_CANCER, RNA.GENE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE=TH.GENE
WHERE RNA.FPKM>TH.THSD 
AND RNA.GENE IN (
	SELECT ENSEMBLGENEID
	FROM CONVERTER
	WHERE EXISTS (
		SELECT HUGO_GENE 
		FROM ONCO_GENES 
		WHERE ISTUMORSUPPRESSORGENE = 1) 
	AND ENSEMBLGENEID IS NOT NULL)
GROUP BY RNA.GENE
HAVING NUM_CANCER > 8
ORDER BY NUM_CANCER; 

#7.
# Find the percentage of genes that pass the oncogene filter and are overexpressed given a cancer type

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
		WHERE EXISTS (
			SELECT HUGO_GENE FROM ONCO_GENES WHERE ISONCOGENE = 1)))
/ 
(SELECT COUNT(*) FROM THRESHOLDS) * 100 AS PERCENTAGE; 

#10.
# Given a sample ID, return a list of overexpressed gene and possible type of alterations
SELECT DISTINCT HUGO_GENE, ALTERATIONS
FROM ONCOKB_DRUG
WHERE HUGO_GENE IN (
	SELECT HUGO_GENE
	FROM CONVERTER 
	WHERE EXISTS ( 
		SELECT RNA.GENE
		FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE = TH.GENE
		WHERE RNA.FPKM>TH.THSD AND RNA.SAMPLE = 'TCGA-2F-A9KO-01A')); 

#2.
# SHOW THE DIFFERENT TYPES OF DRUGS GIVEN THAT THE GENE IS A TUMOR SUPPRESSOR AND THE CANCER IS 'OV'
SELECT DISTINCT DR.drugs
FROM oncokb_drug AS DR JOIN onco_genes AS GN ON DR.HUGO_GENE=GN.HUGO_GENE
WHERE GN.IsTumorSuppressorGene = 1
AND EXISTS(
	SELECT Hugo_gene 
	FROM converter
	WHERE (EnsemblgeneID) IN (
		SELECT GENE FROM RNA WHERE CANCER = 'OV')); # 20 sec

#4.
# Find alterations for a given cancer type 
# CREATE A VIEW TO COMPUTE THE AVG OF FPKM OF THE GBM CANCER TYPE
CREATE VIEW FPKM_GBM (GENE,AVG_FPKM) AS
SELECT GENE,AVG(RNA.FPKM) AS AVG_FPKM FROM RNA AS RNA where rna.Cancer = 'GBM' GROUP BY RNA.GENE;

SELECT distinct Alterations
FROM oncokb_drug
WHERE EXISTS ( 
	SELECT Hugo_gene 
	FROM converter
	WHERE (EnsemblgeneID) in (
		SELECT TH.GENE
		FROM THRESHOLDS AS TH JOIN FPKM_GBM AS FPKM_GBM ON TH.GENE=FPKM_GBM.GENE
		WHERE TH.thsd<FPKM_GBM.AVG_FPKM)); #2 sec

#5.
# Find the sample which could be treated with the greates number of drugs
SELECT SAMPLE, MAX(NUM_SAMPLE) AS MAX_DRUGS_PER_SAMPLE
FROM (
	SELECT COUNT(RNA.SAMPLE) AS NUM_SAMPLE,RNA.SAMPLE
	FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE = TH.GENE
	WHERE RNA.FPKM>TH.THSD
	AND EXISTS ( 
		SELECT ENSEMBLGENEID
		FROM CONVERTER
		WHERE HUGO_GENE IN (
			SELECT HUGO_GENE
			FROM oncokb_drug))
			GROUP BY RNA.SAMPLE) AS MAX_SAMPLE; #2.5 sec
#6.
# Show the gene whose number of drugs associated is more than 2 but are not oncogene
SELECT HUGO_GENE, IsTumorSuppressorGene
FROM oncokb_drug JOIN onco_genes USING (hugo_gene)
WHERE isoncogene = 0
GROUP BY hugo_gene
HAVING COUNT(drugs) > 2
ORDER BY COUNT(drugs) desc; #0.06 sec


#8.
# Find ensembl gene id subjected to a specific type of alteration 
SELECT EnsemblgeneID AS ensemble_gene 
FROM converter 
WHERE (Hugo_gene) IN (
	SELECT Hugo_gene FROM oncokb_drug WHERE alterations = 'Fusions'); #0.15 sec

#9.
# Find those genes (or the gene) that do not pass threshold even if they are annotated in oncokb
SELECT DISTINCT RNA.GENE
FROM RNA AS RNA JOIN THRESHOLDS AS TH ON RNA.GENE=TH.GENE 
WHERE RNA.FPKM<TH.THSD 
AND (RNA.GENE) IN (
	SELECT EnsemblgeneID 
	FROM CONVERTER 
	WHERE (HUGO_GENE) IN (
		SELECT HUGO_GENE FROM ONCO_GENES WHERE ISONCOGENE = 1)); #0.17 sec
