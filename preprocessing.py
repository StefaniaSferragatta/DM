import pandas as pd
rna = pd.read_csv('rna.csv', index_col=0)
converter = pd.read_csv('converter_null.csv', names=['NCBI','Hugo'], index_col=1)
l = list(set(converter.index).intersection(set(rna.index)))
converter.loc[l]
d = dict(zip(converter.index,converter['Hugo']))
rna['Hugo'] = ''
rna['Hugo'] = rna.index.map(d)
rna = rna.reset_index()
rna.to_csv('rna.csv',sep=' ', index=False)
onco = pd.read_csv('onco_genes.csv', header=0,names=['Hugo_gene','x','Oncokbannotated','Isoncogene','Istumorsuppressorgene'])
onco = onco.drop(['x'],axis=1)
d2 = {'Yes':1,'No':0}
onco['Oncokbannotated'] = onco['Oncokbannotated'].map(d2)
onco['Isoncogene'] = onco['Isoncogene'].map(d2)
onco['Istumorsuppressorgene'] = onco['Istumorsuppressorgene'].map(d2)
rna.to_csv('onco.csv',sep=' ', index=False)
drug = pd.read_csv('oncokb_drug.csv', header=0, names=['Hugo_gene','Alterations','Cancertypes','Drugs'])
drug.to_csv('drug.csv',sep=' ', index=False)


#--------------------------------------------------------------------------

import pandas as pd
rna = pd.read_csv('rna.csv',sep=',')
threshold = rna.groupby('Hugo').mean()['FPKM'].to_dict()
td_df = pd.DataFrame.from_dict(threshold,orient='index')
new_df = pd.merge(td_df,rna,left_index=True,right_on='Hugo')
filtered_df = new_df[new_df[0] < new_df['FPKM']]   
filtered_df = filtered_df[['Sample','Cancer','Hugo']]
filtered_df.to_csv('filtered.csv',sep=',',index=False)
