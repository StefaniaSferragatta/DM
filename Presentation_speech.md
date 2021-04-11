## SLIDE1

- We decided to investigate the relationship between gene expression level and treatment (drugs)
- We have relied on 3 databases and preprocessed the data with python to extract the relevant information (csv)
  1. HPA: level of RNA expressionindividuals) for 132 genes in more than 50 cancer types
  2. ONCOKB: gene mutation annotation - drug association
  3. HGNC: gene ID conversion

## SLIDE2

- The schema of our datasets is structured id 4 tables, to which we added one (threshold) where we stored the varage expression level (FPKM) for each od the 132 genes (ensembl/hugo)
- The main goal is to operate queries with a significant biological meaning
- The key point is that the expression level of a specific gene strongly determines the type of treatment that could be effective for each individual.

## MySQL

- First query: Given a specific drug, how many of the individuals present in the RNA table could potentially be treated for each cancer type ? 
- Second query: Which are the tumor suppressor genes that are overexpressed in at list 8 cancer types in our population? 
- Third query: Given a specific cacncer type, which is the percentage of oncogenes that are actually overexpressed in the population under consideration?
- Fourth query: Given an individual (sample), which are the overexpressed genes and which are the type of mutations known for those genes?
