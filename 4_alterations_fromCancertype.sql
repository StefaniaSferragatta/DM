# Find alterations for cancer type ( RNA → Converter → Onco genes → Onco drugs)
# 1. Seleziona un tipo di tumore → Lista di geni in ensembl 
# 2. Lista di geni in Ensembl → Lista di geni in Hugo
# 3. Lista di geni in Hugo →  Lista di geni in Hugo (if oncogene == yes)
# 4. Lista di geni filtrata → Lista di geni filtrata + tipo di alterazione

SELECT distinct Alterations 
from oncokb_drug
where exists ( #(Hugo_gene) in (
SELECT Hugo_gene 
from converter
where (EnsemblgeneID) in (
SELECT Gene from rna where Cancer = 'GBM'));

