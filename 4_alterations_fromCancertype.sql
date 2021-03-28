# Find alterations for cancer type ( RNA → Converter → Onco genes → Onco drugs)
# 1. Seleziona un tipo di tumore → Lista di geni in ensembl 
# 2. Lista di geni in Ensembl → Lista di geni in Hugo
# 3. Lista di geni in Hugo →  Lista di geni in Hugo (if oncogene == yes)
# 4. Lista di geni filtrata → Lista di geni filtrata + tipo di alterazione

#CREATE A VIEW TO COMPUTE THE AVG OF FPKM OF THE GBM CANCER TYPE
CREATE VIEW FPKM_GBM (GENE,AVG_FPKM) AS
SELECT GENE,AVG(RNA.FPKM) AS AVG_FPKM FROM RNA AS RNA where rna.Cancer = 'GBM' GROUP BY RNA.GENE;

SELECT distinct Alterations
from oncokb_drug
where exists ( 
SELECT Hugo_gene 
from converter
where (EnsemblgeneID) in (
SELECT TH.GENE
FROM thresholds AS TH JOIN FPKM_GBM AS FPKM_GBM ON TH.GENE=FPKM_GBM.GENE
WHERE TH.thsd<FPKM_GBM.AVG_FPKM));
