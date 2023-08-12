""" 
This script is to extract features from vcf.gz file, use fitted `preprocessor` and `model` to predict, write output back to vcf.gz file.

MODEL: LG model trained on imbalanced classes CJP( Clinvar-Justhusky-KI pathogenic) with 29 features, and preprocessor

"""


import gzip
import pandas as pd
import numpy as np
from joblib import dump, load
from sklearn.compose import make_column_transformer
from sklearn.impute import MissingIndicator, SimpleImputer
from sklearn.preprocessing import OrdinalEncoder, StandardScaler
from category_encoders import BinaryEncoder



""" FIRST of ALL-- user need"""

##### please set files
# in
vcfgz_in_file = '/Users/nancy/Desktop/RS_projects/data/03_ML/03_predict_new/origi/justhusky_gatkcomb_rhocall_norm_af_mt_frqf_cadd_vep_parsed_ranked.vcf.gz' ## for example: annotated justhusky.vcf.gz
variant_consequences_order = './variant_consequences.txt'    ## consequence list


# out
extract_out_file = '/Users/nancy/Desktop/RS_projects/result/05_summary/01_justhusky_features_extracted.csv'            ## extracted features.csv
pred_out_simple = '/Users/nancy/Desktop/RS_projects/result/05_summary/01_29feats_CJP_justhusky_pred_out_simple.csv'    ## prediction and score of LG , a simple csv

pred_out_file = '/Users/nancy/Desktop/RS_projects/result/05_summary/01_29feats_CJP_justhusky_pred_out.vcf.gz'          ## final output, justhusky.vcf.gz with prediction and score


##### load fitted preprocessor and model
preprocessor = load('/Users/nancy/Desktop/RS_projects/result/04_ML_modify/01_retrainModel_ClinvarJusthuskyNewpatho/models/01_29feats_ClinJustPatho5-5_preprocessor.joblib')  # preprocessor
LG_model = load('/Users/nancy/Desktop/RS_projects/result/04_ML_modify/01_retrainModel_ClinvarJusthuskyNewpatho/models/01_29feats_ClinJustPatho5-5_LG.joblib')                # LG model




"""START script"""

""" ##  1. Extract data from vcf.gz :
modify csq_name list, it can be different for different version"""


"""1.1 for outside CSQ: get feature names """
features = ['CADD','AF_ESP','AF_EXAC','AF_TGP','Frq','GNOMADAF','GNOMADAF_popmax','Hom','ORIGIN','SPIDEX','SWEGENAF'] ## remove CLNSIG

## get features' value start site
feature_value_start={}
for i in features:
    feature_value_start[i]= (len(i) +1)



"""1.2 for outside CSQ,function: extract features' value """
def extract_feature(features,feature_value_start,info):
    features_outside = []

    if any('SWEGENAAC_Hom=' in str for str in info):             # remove 'SWEGENAAC_Hom=' in advance, avoid mess 'HOM' later
        match = [s for s in info if 'SWEGENAAC_Hom=' in s]       # match is a list, [0] to get str item
        try:
            info.remove(match[0])
        except ValueError:
            pass


    for i in features:
        prefix = (i+'=')   
        if any (prefix in str for str in info):                  # check for the presence 'score' in INFO:
            matching = [s for s in info if prefix in s]          # get the item containing 'score':
            value_start =  feature_value_start[i]          
            features_outside.append(matching[0][value_start:])   # get the value
        else:
            features_outside.append('')                          # if not exist, add empty

    return features_outside                                      # 2D list




"""1.3 for CSQ: give Consequence order """

with open('variant_consequences.txt','r') as f:            # get the 'variant_consequences order' lst: descending severity
    order_conseq=[line.rstrip("\n") for line in f]         # remove the \n at right side of each line; lst

# give consequence order number
orderdic = {v:i for i,v in enumerate(order_conseq)}




"""1.4 for CSQ, function: split transcripts into fields, and clean Consequence cell"""

def split_CSQ_fields(trans_csq,order_conseq,con_idx):   

    for i in range(len(trans_csq)):
            split_trans = trans_csq[i].split('|')         # split each trans into fields as str
                                                                                                             
            cons_sub = split_trans[con_idx].split('&')    # in each trans: split `Consequence` cell inside
            cons_sub.sort(key=order_conseq.index)         # in each trans: order `Consequence` cell inside
            split_trans[con_idx] = cons_sub[0]            # in each trans: only keep the most severe `Consequence` in this cell
            
            trans_csq[i] = split_trans                    # 2D lst
    return trans_csq





"""1.5 for CSQ, function: pick one trans of each variant: `Conseqence` is most severe and `Canonical`==Yes """

def pick_CSQ_trans_final(trans_csq,orderdic,con_idx,CANONICALidx):

    ### order and pick one trans of each variant
    trans_csq.sort(key=lambda x:orderdic[x[con_idx]])     # in each variant: order trans by `Consequence` cell

    found = -1
    for i in range(len(trans_csq)):                       
        if(trans_csq[i][CANONICALidx] == "YES" and trans_csq[i][con_idx] == trans_csq[0][con_idx]):         
            found = i                                 
            break
    if(not found==-1):
        picked_trans=(trans_csq[found] )                  # in each variant: if any trans `Cons` is the most sever and `Canonical`=YES, pick this trans
    else:                                                 # if no any `Canonical`= yes, pick the fist most sever trans
        picked_trans=(trans_csq[0])

    return picked_trans





""" 1.6  main script: extract all features outside and inside CSQ"""


head_line = float('inf')                                            #  as infinity integer

with gzip.open(vcfgz_in_file) as in_f:                                    # read compressed file
    with open(extract_out_file,'w') as out_f:                 # write new file.csv
        
        
                  
        for i,line in enumerate(in_f,0):                           
            content = line.decode('utf8').rstrip('\n') 

            # get csq names: might be different in each file
            if content.startswith('##INFO=<ID=CSQ'):
                csq_name_split = content.split('Format:')[1].split('|')   
                con_idx = csq_name_split.index('Consequence')             ## get some fields' index used in order csq transcript
                CANONICALidx = csq_name_split.index('CANONICAL')
            
                
                ### write the head of features outside CSQ and CSQ once
                out_f.write(';'.join(features) +';')                        
                out_f.write(';'.join(csq_name_split)+'\n')


            if content.startswith('#CHROM'):                        # find first line of rec 
                rec_head=content.split('\t')                        # rec head line: split str to list
                INFOidx = rec_head.index('INFO')                    # get INFO idx
                head_line = i


            if i > head_line:
                rec_lst=content.split('\t')                                                  # lst: get each variant line , split str

                ### extract features outside CSQ
                info = rec_lst[INFOidx].split(';')                                           # lst: get each INFO line               
                feature_line = extract_feature(features,feature_value_start,info)            # get each feature line

                ### extract CSQ
                trans_csq = rec_lst[INFOidx].split('CSQ=')[-1].split(";")[0].split(",")       # in each variant: get csq's transcripts , lst
                trans_csq = split_CSQ_fields(trans_csq,order_conseq,con_idx)                  # in each variant: splite each transcript into fields, and ordered by `Consequence``
                picked_trans = pick_CSQ_trans_final(trans_csq,orderdic,con_idx,CANONICALidx)  # in each variant: pick one transcript which `Conseqence` is most severe and `Canonical`==Yes """
                
                ### write down
                out_f.write(';'.join(feature_line) +';')           
                out_f.write(';'.join(picked_trans) +'\n')           

       




print(" 1. finish: Extract data from vcf.gz")





""" ##  2. Data preprocessing and prediction ## """

df = pd.read_csv(extract_out_file,sep=';')   # index_col=False:    not use the first column as the index
df['idx'] = df.index  # add index column: in case some subsequent process for `df_1`` will change idx of ori, like delet some rows...

""" 2.1 choose featuresV1"""

featureV1 = ['idx','CADD', 'AF_TGP', 'Frq', 'IMPACT','GNOMADAF_popmax', 'Hom', 'ORIGIN',
       'SPIDEX', 'SWEGENAF', 'Consequence', 'BIOTYPE', 'SIFT',
       'PolyPhen', 'MES-SWA_acceptor_alt', 'MES-SWA_acceptor_diff',
       'MES-SWA_donor_alt', 'MES-SWA_donor_diff', 'MaxEntScan_alt',
       'MaxEntScan_diff', 'GERP++_RS', 'REVEL_score',
       'phastCons100way_vertebrate', 'phyloP100way_vertebrate', 'LoFtool',
       'pLI_gene_value', 'SpliceAI_pred_DS_AG', 'SpliceAI_pred_DS_AL',
       'SpliceAI_pred_DS_DG', 'SpliceAI_pred_DS_DL']         # remove CLNSIG,   add index: 29+1 total

df_1 = df[featureV1]



""" 2.2 preprocessing and predict """

## predict function :
def predict_score(X, model, preprocessor, df_ori):
    # Use preprocessor and model to predict on new data
    X_processed = preprocessor.transform(X)
    pred = model.predict(X_processed)
    prob = model.predict_proba(X_processed)

    # put prediction and score back to dataframe with same index
    df_out = pd.DataFrame(data = [pred,prob[:,1]]).T
    df_out.columns = ['prediction','score']
    df_out['score']=df_out['score'].round(3)
    df_out = pd.concat([X['idx'],df_out],axis=1)

    #  write model outputs in original df at same index rows
    df_copy = df_ori.copy() 
    df_merged = pd.merge(df_ori,df_out, on='idx')    # get only rows merged when index is same
    df_copy.loc[df_copy['idx'].isin(df_merged['idx']),['prediction','score']] = df_merged[['prediction','score']].values  # put cells of merged in original dataframe
    lst = ['prediction','score']
    return df_copy[lst]

# data preprocessing and predicted by models
df_lg = predict_score(df_1,LG_model,preprocessor,df)    # now the ouput has same length with original file

df_lg.to_csv(pred_out_simple,index=False)




print(" 2. finsh: Data preprocessing and prediction")





""" ##  3. Write output back in vcf.gz ## """

head_line = float('inf') 
idx = 0

with gzip.open(vcfgz_in_file,'rb') as in_f:           
    with gzip.open(pred_out_file,'wb') as out_f1:           # decode and encode: for compressed file

        for i,line in enumerate(in_f,0):                           
            content = line.decode('utf8').rstrip('\n')     # rstrip: remove characters \n at the end a string

            ##  find first line of rec
            if content.startswith('#CHROM'):                         
                rec_head=content.split('\t')                        # rec head line: split str to list
                INFOidx = rec_head.index('INFO')                    # get INFO idx
                head_line = i

            ## add prediction and score at the end of `INFO`` column
            if i > head_line:
                rec_lst=content.split('\t')                         # lst: get each variant line , split str

                if np.isnan(df_lg.iloc[idx]['prediction']):         # if score is null, add nothing
                    contentout = line
                else:
                    info = [rec_lst[INFOidx]+ ';LGrank_pred='+ str(int(df_lg.iloc[idx]["prediction"])) + ';LGrank_score=' + str(df_lg.iloc[idx]["score"])]                 
                    entire_line= rec_lst[:INFOidx] + info + rec_lst[INFOidx+1:]
                    contentout = ('\t'.join(entire_line) +'\n').encode()
                
                out_f1.write(contentout)  
                idx +=1
            
                continue          # go back up to the for loop top, never visit next step

            ## write head lines: before 'if i > head_line'
            out_f1.write(line)      
            
            ## write model description in the head area:
            if content.startswith('##INFO=<ID=RankResult'):
                pre = '##INFO=<ID=LGrank_pred,Number=.,Type=String,Description="The binary prediction for this variant: 1 - pathogenic, 0 - benign; The score threthold is 0.5, score >= 0.5 -- pathogenic, score < 0.5 -- benign ">\n'
                score = '##INFO=<ID=LGrank_score,Number=.,Type=String,Description="The rank score for this variant prediction, scores range from 0 to 1, showing the level of confidence of the prediction, with 0 representing a higher likelihood of being benign and 1 indicating a higher likelihood of being pathogenic.">\n'
                out_f1.write((pre + score).encode())



print(" 3. finish: Write output back in vcf.gz")