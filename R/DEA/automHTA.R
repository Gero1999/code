library(Biobase); library(oligoClasses)
#Annotation and data import packages
library(ArrayExpress); library(GEOquery)
library(pd.hugene.1.0.st.v1); library(hugene10sttranscriptcluster.db)
library(hugene20sttranscriptcluster.db); library(hugene20stprobeset.db); library(pd.hugene.2.0.st)
#Quality control and pre-processing packages
library(oligo); library(arrayQualityMetrics); library(affyQCReport)
#Analysis and statistics packages
library(limma); library(topGO); library(ReactomePA); library(clusterProfiler)
#Plotting and color options packages
library(gplots); library(ggplot2); library(geneplotter); library(RColorBrewer);library(pheatmap); library(enrichplot)
#Formatting/documentation packages
library(dplyr); library(tidyr)
#Helpers:
library(stringr); library(matrixStats); library(genefilter); library(openxlsx)


# Functions

discard_redundant_cols = function(df){
# Simplify all categories to numbers  (One-hot encoding)
col_simplification = function(col){
  dicc = setNames(c(1:length(unique(col))), unique(col))
  return(sapply(col, function(x){unname(dicc[x])}))
}

# Duplicated cols, cols with all 1s and cols without var-groups (1,2,3...nrow) are removed
final_df = as.data.frame(df[,!(duplicated(t(new_df)) | colSums(new_df)==nrow(new_df) | colSums(new_df)==sum(c(1:nrow(new_df))))])
colnames(final_df) = colnames(df)[!(duplicated(t(new_df)) | colSums(new_df)==nrow(new_df) | colSums(new_df)==sum(c(1:nrow(new_df))))]
return(final_df)
}


discard_non_replicated_categ = function(df, min_replicates){
  # Set as NA those categories/values with less than the minium number of biological
  # replicates accepted by the user (min_replicates) in the dataframe given (df).
  usable_cols = c()
  for (n_col in 1:ncol(df)){
    del_values = names(table(df[,n_col])[table(df[,n_col])<min_replicates])
    df[,n_col][df[,n_col] %in% del_values] = NA
    # If any column is left with less than two comparing variables discards it
    if (length(table(df[,n_col]))>1){usable_cols = c(usable_cols, n_col)}
  }
  return(df[,usable_cols])
}


reduce_label_language = function(df){
  for (n_col in 1:ncol(df)){
    for (preposition in c('with', 'and', 'at', 'for')){
      df[,n_col]=gsub(preposition, '', df[,n_col])}
    for (sub_n in 1:10){
      df[,n_col]=gsub(c('deci', 'centi', 'milli', 'micro', 'nano', 'pico', 'liter', 'molar', 'mole', 'meter')[sub_n], 
                      c('d', 'c', 'm', 'μ', 'n', 'p', 'L', 'M', 'M', 'm')[sub_n], 
                      x = df[,n_col])}
    df[,n_col]=gsub(' ', '_', df[,n_col])
  }
  return(df)
}








# Info to introduce #
wd = '/home/mrgerry/Escritorio/Prueba_Github/'
array_ids = ''


target = '([cC]ytarabine.*)|([Aa]ra[Cc].*)'  # Put a regular expression matching your specific target of study
control = '([Nn]one)|([Cc]ontrol)'      # Put a regular expression matching your specific control of study
col_target_name = 'Treatment'

min_replicates = 3                      # Minimum number of replicates accepted for each studied category in the dataset
colVec = c('darkseagreen1', 'darkseagreen2', 'darkseagreen3', 'darkseagreen4', 'springgreen4', 'seagreen')   # Pon varios colores que vayan en el bucle cambiando, ponlos de  3 en 3 (para tener varios en cada dataset)
idVec = c('E-MTAB-4895', 'E-GEOD-5681', 'GSE32992')

#################################
id = 'E-MTAB-4895'
raw_data_dir <- tempdir()                          
if (!dir.exists(raw_data_dir)) {
  dir.create(raw_data_dir)}

# Download the microarray data
anno_AE <- getAE(id, path = raw_data_dir, type = "raw")
SDRF = read.delim(file.path(raw_data_dir, anno_AE$sdrf)); write.csv(SDRF, 'SDRF_original')
files = SDRF[,intersect(grep('^[Aa]rray.Data',colnames(SDRF)), grep('.*((txt)|(CEL))', SDRF))]

# Reduce metadata information (SDRF)
SDRF = SDRF[,grep('([Ff]actor.*)|([Cc]haracteristics.*)', colnames(SDRF))]  # Choose columns with clinical information
SDRF = discard_redundant_cols(SDRF)  # Discard duplicated or redundant info 
                                                                                                                                                                                                                                                                                                                                                                SDRF = discard_non_replicated_categ(SDRF, min_replicates)  # Set as NA values with less than the num biological replicates considered as min
SDRF = reduce_label_language(SDRF)  # Simplify the names of the distinct categories
SDRF$Array.Data.File = files; write.csv(SDRF, 'SDRF_modified')
#colnames(SDRF)[grep(target, SDRF)] = col_target_name






# Read raw data depending on the platform used (Affymetrix)
ADF = read.table(file.path(raw_data_dir, grep('adf', anno_AE, value=TRUE)), sep='\n')[1,]


# Affymetrix
if (grepl('.*[Aa]ffymetrix.*', ADF)==T){raw_data <- read.celfiles(filenames = file.path(raw_data_dir, SDRF$Array.Data.File), 
                                                                  verbose = FALSE, phenoData = AnnotatedDataFrame(SDRF))}
norm_data <- oligo::rma(raw_data)
col_target = pData(raw_data)[grep(col_target_name, colnames(pData(raw_data)))]

raw_expr = log2(expr(rma(raw_set, normalize=F)))
norm_expr = log2(expr(rma(raw_set, normalize=T)))


# Expression analysis results
dir.create('EA_results'); setwd(paste(working_dir, 'EA_results', sep=''))


## Boxplot
png(file=paste('preNUSE', idVec[i], sep='_'), width=260, height=260)
oligo::boxplot(raw_data, target = "core", main = paste0("Boxplot of the raw data (", id, ' )', sep=''), 
               cex.main=0.9, cex.axis=0.65, ylab='Intensity (Log2)', xlab='Sample ID')

## PCA



ggplot(raw_set, aes(y=value, x=reorder(time,value), col=time))+geom_boxplot()+theme_bw()
str(raw_data)

dev.off()

png(file=paste('NUSE', idVec[i], sep='_'), width=260, height=260)
oligo::boxplot(norm_data, col=colVec[i], target = "core", main = paste(vector_design_dataset[i],':  ', colVec[i], sep=''),cex.main=1.2, cex.axis=0.65, cex.lab=0.82, ylab = 'Intensidad de fluorescencia (Log2)', xlab='Muestras (ID)')
dev.off()




PCA = prcomp(t(raw_set))
percentVar = round(100*PCA$sdev^2/sum(PCA$sdev^2),1); sd_ratio = sqrt(percentVar[2] / percentVar)

dataGG <- data.frame(PC1 = PCA$x[,1], PC2 = PCA$x[,2],
                     #Dose =     #Emplean la misma dosis
                     #Biobase::pData(norm_data)$Factor.Value.dose.,
                     Target = col_target)
















# Agilent  --> I stopped because obtaining the annotation file becomes so complicated :/  (DS6)
if(grepl('.*[Aa]gilent.*', ADF)==TRUE){}

raw_data <- read.maimages(file.path(raw_data_dir, SDRF$Array.Data.File),source = 'agilent.median',       ### Agilent median!    onlyGreen 
  green.only = TRUE, other.columns = 'gIsWellAboveBG')























target_col = grep(target, colnames(SDRF))

# Select factor values (relevant clinical info)
SDRF[,grep('([Ff]actor.*)|([Cc]haracteristics.*)', colnames(SDRF))]









anno_AE <- getAE(id, path = raw_data_dir, type = "raw")
