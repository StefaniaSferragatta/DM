# DM

Database: 
- OncoKB: FDA approved dugs (level 1) https://www.oncokb.org/actionableGenes#levels=1 
- OncoKB: OncoKB Cancer Gene List https://www.oncokb.org/cancerGenes
- Custom HGNC converter: https://www.genenames.org/download/custom/ (https://www.genenames.org/cgi-bin/download/custom?col=gd_hgnc_id&col=gd_app_sym&col=gd_pub_ensembl_id&status=Approved&status=Entry%20Withdrawn&hgnc_dbtag=on&order_by=gd_app_sym_sort&format=text&submit=submit)
- RNA TCGA cancer sample gene data (22): https://www.proteinatlas.org/about/download

## Index

**B-tree:**

Is a tree data structure popular for use in database indexes. The structure is kept sorted at all times, enabling fast lookup for exact matches (equals operator) and ranges (for example, greater than, less than, and BETWEEN operators). This type of index is available for most storage engines, such as InnoDB and MyISAM. Because B-tree nodes can have many children, a B-tree is not the same as a binary tree, which is limited to 2 children per node.
Contrast with hash index, which is only available in the MEMORY storage engine. The MEMORY storage engine can also use B-tree indexes, and you should choose B-tree indexes for MEMORY tables if some queries use range operators.

- [How MySQL uses Index](https://dev.mysql.com/doc/refman/8.0/en/mysql-indexes.html#:~:text=Most%20MySQL%20indexes%20(%20PRIMARY%20KEY,described%20in%20the%20following%20discussion)

- [Btree vs Hash](https://dev.mysql.com/doc/refman/8.0/en/index-btree-hash.html)
