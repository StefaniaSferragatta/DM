## SLIDE1

- We decided to investigate the relationship between gene expression level and treatment (drugs)
- We have relied on 3 databases and preprocessed the data with python to extract the relevant information (csv)
  1. HPA: more than 600000 records of RNA expression level for 132 genes in more than 50 cancer types
  2. ONCOKB: gene mutation annotation - drug association
  3. HGNC: gene ID conversion

## SLIDE2

- The schema of our datasets is structured id 4 tables, to which we added one (threshold) where we stored the varage expression level (FPKM) for each od the 132 genes (ensembl/hugo)
- The main goal is to operate queries with a significant biological meaning
- The key point is that the expression level of a specific gene strongly determines the type of treatment that could be effective for each individual.

## MySQL

- First query: Given a specific drug, how many of the individuals could potentially be treated for each cancer type ? 
- Second query: Which are the tumor suppressor genes that are overexpressed in at list 8 cancer types in our population? 
- Third query: Given a specific canCcer type, which is the percentage of oncogenes that are actually overexpressed in the population under consideration?
- Fourth query: Given an individual (sample), which are the overexpressed genes and which are the type of mutations known for those genes?


## OPTIMIZATION
- Changing the schema [deleting 'Converter' table, added Hugo to RNA]
- Adding integrity constraints [domain constraints (defining a set of valid values for each attribute), the entity integrity constraint (primary key value cannot be null because it is used to identify individual rows in relation)]
- Adding indexes [used to quickly find rows with specific column values. The B-Tree data structure allows you to quickly find a specific value, a set of values or a range of values, corresponding to the operators as =,>, ≤, between, in, and so on, in a 'WHERE' clause. Without an index, MySQL must read each line of the table in sequence.]
- There was no need to add more views to those already created.
