# Find ensembl gene id subjected to a specific type of alteration 
SELECT EnsemblgeneID as ensemble_gene 
from converter 
where (Hugo_gene) in (SELECT Hugo_gene from oncokb_drug where alterations = 'Fusions');