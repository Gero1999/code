# Se cargan las librerías requeidas 

#Librerías de búsqueda
library(Biobase); library(oligoClasses)
library(ArrayExpress); library(GEOquery)

#Librerías de anotación
library(pd.hugene.1.0.st.v1); library(hugene10sttranscriptcluster.db)
library(hugene20sttranscriptcluster.db); library(hugene20stprobeset.db)
library(pd.hugene.2.0.st)

#Librerías del control de calidad y análisis
library(oligo); library(arrayQualityMetrics); library(affyQCReport)
#Analysis and statistics packages
library(limma); library(topGO); library(ReactomePA); library(clusterProfiler)
#Plotting and color options packages

#Librerías de representación y visualización
library(gplots); library(ggplot2); library(geneplotter); library(RColorBrewer);library(pheatmap); library(enrichplot)

# Librerías de manipulación de datos
library(dplyr); library(tidyr)
#Helpers:
library(stringr); library(matrixStats); library(genefilter); library(openxlsx)
library("ArrayExpress")
library("arrayQualityMetrics")
library("geneplotter")
library("vsn")




# Búsqueda en repositorios de los datos de interés y selección de aquellos con metadata de interés

Search = readline(prompt="Enter your search: ")
Data_type = readline(prompt="Type of Data desired: raw or processed ? ")
Name_analysis = readline(prompt="How do you want to name your analysis? ")
dir.create(paste(getwd(), Name_analysis, sep='/'))

finding = queryAE(Search)
if (Data_type == 'raw'){finding=subset(finding, Raw=='yes')}
if (Data_type == 'processed'){finding=subset(finding, Processed=='yes')}
else {print('Error in Data_type; Please introduce    raw    or    processed    ')}

discarded = c()
for (line in 1:nrow(finding)){
  print(finding[line,c('ID', 'Species', 'ExperimentFactors')])
  Confirmation = readline(prompt="Want to keep it? (y/n) ")
  while (!Confirmation=='n'&&!Confirmation=='y'){print('Error, write yes or no (y/n). Repeating...'); Confirmation = readline(prompt="Want to keep it? (y/n) ")}
  if (Confirmation=='n'){discarded = c(discarded, line)}
  if (Confirmation=='y'){print('Kept')}}
finding = finding[-discarded,]





# Pre-procesamiento de muestras

for (line in 1:nrow(finding)){
  id = finding[line,'ID']; dir_data = paste(getwd(), Name_analysis, id, sep='/')
  dir.create(dir_data); setwd(dir_data)#; raw_data_dir = paste(dir_data, 'RAW', sep='/')
  raw_data_dir <- tempdir()                          
  if (!dir.exists(raw_data_dir)) {
    dir.create(raw_data_dir)}
  AE_data = getAE(id, path=raw_data_dir, type=Data_type)
  if (Data_type=='processed'){break}
  #File names
  file1 = paste("Wild-PCA.pdf",id, sep='-'); file2 = paste( "preNUSE.pdf",id, sep='-'); file3 = paste( "RLE.pdf",id, sep='-')
  ADF = read.table(file.path(raw_data_dir, grep('adf', AE_data, value=TRUE)), sep='\n')
  SDRF = read.delim(file.path(raw_data_dir, grep('sdrf', AE_data, value=TRUE)))
  if(grepl('Agilent', ADF[1,])==T){micro_type = 'Agilent'}{
    
  }
  if(grepl('Affymetrix', ADF[1,])==T){
    micro_type = 'Affymetrix'
    SDRF = read.delim(file.path(raw_data_dir, grep('sdrf', AE_data, value=TRUE)))
    grep('Array', colnames(SDRF))
    
    discarded=c()
    for (n.col in 1:ncol(SDRF)){
      if (n_distinct(SDRF[,n.col])<2{discarded = (discarded, )}
      if (n_distinct(SDRF[,n.col])==nrow(SDRF)){
        if ()
      }
    }
    n_distinct()
  }
  if(grepl('Agilent', ADF[1,])==F && grepl('Affymetrix', ADF[1,])==F){break; print(paste(id, ':  Microarray format not available (or not found in ADF). ', 'We can only process Agilent or Affymetrix data', sep=''))}
}
}


# Busca los valores determinantes (que por convención suelen presentar el nombre de columna "Factor.Value, pero es editable)

fac.names = grep('Factor.Value',colnames(pData(dataset_final)), value=T) #Entre los nombres columnas del phenoData busca aquellas que sean factores de valor (fenotipos)
facs = pData(dataset_final)[,fac.names]  
f = factor(facs)

# Linealización y diseño
design = model.matrix(~0+f)
colnames(design) = levels(f)
fit = lmFit(dataset_final, design)
fit2 = contrasts.fit(fit, cont.matrix)

#Desarrollo del análisis de expresión diferencial (eBayes) con el ajuste de Benjamini-Hockelberg. Guarda los resultados
fit2 = eBayes(fit2)
res = topTable(fit2, coef=1, adjust.method = 'BH', number= nrow(fData(dataset_final)))
write.csv(res, file= paste("eBayes", i, sep='')





# Trabajo sobre RNA-SEQ

library(ggplot2); library(DESeq2); library(pheatmap); library(apeglm)
id = 'Introduce_código_ID_ENA'

#Constuye la matriz (Debes personalizarla al metadata de tu análisis)
sampleTable = data.frame(SampleName = paste(replicate(10, 'GSM43055'), c(55:64), sep=''), AML = c(replicate(6, '1566'), replicate(4, '2741')), Treatment = c(replicate(3, 'Vehículo'), replicate(3, 'AraC'), replicate(2,'Vehículo'), replicate(2,'AraC')))
sampleTable$Descr = paste(sampleTable$Treatment, sampleTable$AML, sep='-')
rownames(sampleTable)=c('SRR11058687','SRR11058688' ,'SRR11058689', 'SRR11058690', 'SRR11058691','SRR11058692','SRR11058693', 'SRR11058694','SRR11058695','SRR11058686')
sampleTable = sampleTable[order(rownames(sampleTable)),]


#Diseña una nomenclatura para tus muestras
vector_design_dataset = c('R1', 'R2'); i =1
sample.designation = function(array, compound.col, compound.grepname){
  return(data.frame("Original"=array, "New"= make.unique(paste(vector_design_dataset[i], ifelse(compound.col==compound.grepname, 'A', ifelse(compound.col=='Control', 'C', 'D')), sep=''), sep='')))
}
array=rownames(sampleTable); compound.col = sampleTable$Treatment; grepfor = 'AraC'

sample_desig = sample.designation(array=array, compound.col = compound.col, compound.grepname = grepfor)
setwd("~/Escritorio/METAML/RNAS-METAML/R1")
write.csv(file='Sample_Designation', sample_desig)

rownames(sampleTable)= sample_desig$New
sampleTable$SampleName = sample_desig$New


#Carga los archivos producidos por STAR (Readfiles)
setwd("~/migoogledrive/TFG/RNA-S/PRJNA605820/")
ReadFiles = sort(list.files(pattern="*ReadsPerGene*")); TabExp = as.data.frame(read.table(ReadFiles[1], sep='\t')[,1])

for (sample in rownames(sampleTable)){
  samExp = read.table(grep(pattern=sample,x=ReadFiles, value = T), sep='\t')[,2]     # Change the column 2 depending if it is unstranded-RNAseq or not
  TabExp = cbind(TabExp, samExp)
}
rownames(TabExp)=TabExp[,1]; TabExp = TabExp[,-1];  TabExp = TabExp[-c(1,2,3,4),]  #Put rownames, eliminate column and rows of no interest 
colnames(TabExp)=rownames(sampleTable)
colnames(TabExp)=sample_desig$New


# Elabora el Wald test con los detalles del contraste deseado y el grado de significación 
dds = DESeqDataSetFromMatrix(countData = TabExp, colData=sampleTable, design= ~AML + Treatment)
dea = DESeq(dds)
res = results(dea, contrast=c('Treatment', "AraC", 'Vehículo'), alpha = 0.1)


#Genera la anotación y agregala a los resultados guardados
resAnnot <- getBM(
  filters="ensembl_gene_id_version",
  attributes=c("ensembl_gene_id_version","ensembl_gene_id", "hgnc_symbol", 'description'),
  values=names(resLFC$log2FoldChange),
  mart=mart)

res.final = merge(x=as.data.frame(resLFC), y=resAnnot, by.x="ensembl_gene_id_version", by.y ="ensembl_gene_id_version")
write.csv(res.final, file='R1-WholeGenesDE2.csv')
