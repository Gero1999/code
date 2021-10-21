# Libraries 
library(dplyr); library(enrichR); library(clusterProfiler); library(clusterProfiler); library(org.Hs.eg.db); library(VennDiagram)
library(enrichR); library(clusterProfiler); library(rrvgo); library(ggplot2)


##### Set all the necessary info for the analysis #####################################################################################################################################

working_dir = ("add/your/working/path")
setwd(working_dir)
# Load data. Define lists with the expression analysis files and the names that you desire to give them
# NOTE: Make sure that the assign_data_name_file possess the correct reading function of your file (Default: read.csv)
file_path_list = list("path1", "path2", "path3", '')
file_name_vect = c('D1', 'D2', 'D3', '')
file_org_vect = c(org.Hs.eg.db, org.Hs.eg.db, org.Hs.eg.db)  #Specify without "" the organism/procedence of each dataset (Human: org.Hs.eg.db, Mouse: org.Ms.eg.db)
organism = org.Hs.eg.db                         # Specify the unique organism that you are going to use in your GO enrichment analysis
project_name = 'Proyect1'

#  Enrichment analysis interests to recopilate in different iterations (vectors). More int values into the vectors would require more iterations. Different subfolders would distingish the output.

adj_values_to_iterate = c()     # Select those genes with less than these particular p.adj (NOTE: Always order them in DESCENDING order)
logFC_to_iterate = c()          #  minimum +-logFC necessary to consider a gene significantly over/under-expressed
min_sets_to_iterate = c()       # In how many of the files the significative gene might be present (being significative)

######################################################################################################################################################################################


# Different functions used to assign name to objects, files or to discard duplicated information in datasets, geneLists (ENSEMBL named vector with LogFC) or GSEA functions simplified

assign_obj_name <- function(name_obj, value) {
  eval(substitute(name <- obj, list(name = as.name(name_obj), obj =value)))
}
assign_data_name_file <- function(name_obj, file_path) {
  eval(substitute(name <- obj, list(name = as.name(name_obj), obj = read.csv(file_path))))
}

discardDuplicates = function(df){
  # Discard all ENSEMBL genes duplicated, selecting those that appear first (file format default: indices ordered by p.adj value)
  df = df[order(df$ENSEMBL, df$adj.P.Val, decreasing =F),]
  df = df[!duplicated(df$ENSEMBL),]
  return(df)
}

genelist = function(set){
  geneList = set$logFC
  names(geneList)=set$ENSEMBL
  geneList = geneList[!duplicated(names(geneList))]
  return(geneList = sort(geneList, decreasing=T))
}

gsea = function(genelist, organism_gsea){
  gseGO(geneList=genelist,
        ont='BP', keyType = 'ENSEMBL',
        pvalueCutoff = 0.2, pAdjustMethod = 'BH',
        OrgDb = organism_gsea, verbose=TRUE)
}

# Assign file/data names
data = Map(assign_data_name_file, file_name_vect, file_path_list)

# Eliminate duplicated and not annotated (ENSEMBL) genes.
universe_ens = c(); total_gsea = data.frame()
for (n_df in 1:length(data)){
  df = data[[n_df]]
  df = df[!is.na(df$ENSEMBL),]  # Eliminate not annotated genes
  df = discardDuplicates(df)    # Discard duplicated genes
  data[[n_df]]=df               # Store the edited data
  universe_ens = c(universe_ens, df$ENSEMBL)  # Create a list of all ensembl studied, which would be useful in the future enrichment analysis
 
# Gene set enrichment analysis
  genelist_gsea = genelist(df)
  GSEA = gsea(genelist = genelist_gsea, file_org_vect[n_df])
  GSEA = GSEA@result; GSEA$set = names(data)[n_df]
  total_gsea = rbind(total_gsea, GSEA)
}

total_gsea$p.adj_cutoff = ifelse(total_gsea$p.adjust<0.05, 0.05, ifelse(total_gsea$p.adjust<0.1, 0.1, ifelse(total_gsea$p.adjust<0.2, 0.2, ">0.2")))
total_gsea = total_gsea[order(total_gsea$p.adj_cutoff),]
data_GSEA = data.frame(matrix(ncol=(4+length(data)), nrow=length(unique(total_gsea$ID))))
colnames(data_GSEA) = c('ID', 'Description', 'Common_ENSEMBL_genes', 'max_p_adj', paste0('NES_', names(data)))

id = "GO:0030278"; pos = 0
for (id in unique(total_gsea$ID)){
  pos = pos + 1
  filas = total_gsea[total_gsea$ID==id,]
  descr = total_gsea[total_gsea$ID==id,]$Description[1]
  common_ens = paste(Reduce(intersect, strsplit(filas$core_enrichment, split = '/')),collapse = '/')
  max_p_adj = max(filas$p.adjust_cutoff)
  ordered_NES = c()
  for (name in names(data)){
    if (length(filas[filas$set==name,]$NES)>0){
      ordered_NES = c(ordered_NES, filas[filas$set==name,]$NES)}
    else {ordered_NES = c(ordered_NES, NaN)}}
  data_GSEA[pos,] = c(id, descr, common_ens, max_p_adj, ordered_NES)
}

wd = paste0(working_dir, 'GSEA')
dir.create(wd); setwd(wd); write.csv(file= paste0('GSEA_', project_name), x = data_GSEA)
  

# Venn diagram (Visualization of coincidences) & Pathway enrichment with mutual significative genes
for (p.adj in c(0.2,0.1,0.05)){
  wd = dir.create(paste0(working_dir, '_FDR_', as.character(p.adj*100)))  # Create different files with different FDR
  setwd(paste0(working_dir, '_FDR_', as.character(p.adj*100)))
  
  
  # 1) Discard non significative genes (<adj.p.value)
  # 2) Create list with ENSEMBL info from each file (Reason: This is the input required for the venn.diagram function)
  # 3) Create a dataframe with all the information/genes that we are lately going to use
  ENSEMBL_list = vector(mode='list', length(data)); total_genes = data.frame()
  for (n_df in 1:length(data)){
    data[[n_df]] = data[[n_df]][data[[n_df]]$adj.P.Val<p.adj,]
    ENSEMBL_list[[n_df]] <- data[[n_df]]$ENSEMBL
    
    data[[n_df]]$set = names(data)[n_df]
    total_genes = rbind(total_genes, data[[n_df]])
  }

  # Create Venn Diagram
  venn.diagram(
    x=ENSEMBL_list, category.names = names(data),
    filename = paste0('VennDiagram_',as.character(p.adj), '.png'), 
    main = paste0('Diagrama de Venn: ', project_name),
    output=TRUE, na='remove', main.cex = 0.47, main.fontfamily = 'Times', main.pos = c(0.5, 0.9),
    main.just = c(0.5, 0.5), main.fontface = 'bold',
    # Output features
    imagetype="png", height = 500 , width = 500 , resolution = 300, compression = "lzw",
    # Circles
    lwd = 2, lty = 'blank', fill = c('royalblue2', 'darkorange2', 'seagreen', 'gray85', 'red', 'yellow')[1:length(data)],
    # Numbers
    cex = 0.26, fontface = "plain", fontfamily = "sans",
    # Set names
    cat.cex = 0.34, cat.fontface = "plain", cat.default.pos = "outer", cat.pos = replicate(length(data), 0),
    cat.dist = c(NULL, c(0.02,0.02),c(0.03,0.03,-0.435),c(-0.35,-0.35,0.1,0.1), c(0.08, 0.08, -0.08, -0.08, 0.08))[length(data)],
    cat.fontfamily = "Times", margin=0.17
  )
  
  
  # Summarise all the information (coincidences, average logFC, concordance...) in one unique dataframe to inspect
  data_genes = data.frame(GENENAME=character(0), logFC_avg=numeric(0), Coherencia = numeric(0), N.datasets=numeric(0), Datasets=character(0), Dir_expr = character(0), std_error=numeric(0), ENSEMBL=character(0))
  for (i in unique(total_genes$ENSEMBL)){                                       
    filas = na.omit(total_genes[total_genes$ENSEMBL==i,])
    N.data = n_distinct(filas$set)
    datasets = paste(filas$set[order(filas$set)], collapse='-')
    direction = paste(ifelse(filas$logFC>0, "+", "-")[order(filas$set)], collapse='')
    standard_err = round(sd(filas$logFC)/sqrt(length(filas$logFC)), digits = 3)
    
    if (abs(sum(filas$logFC))==sum(abs(filas$logFC))){coherence = 'yes'}
    else{coherence = 'no'}
    row_data_genes = data.frame(GENENAME=filas[1,'GENENAME'], logFC=mean(filas$logFC), Coherence = coherence, N.datasets=N.data, Datasets = datasets, Dir_expr = direction, std_error = standard_err, ENSEMBL=i)
    data_genes = rbind(data_genes, row_data_genes)
  }
  write.csv(x=data_genes, file=paste0('data_genes_', as.character(p.adj)))}

  data_genes$logFC
  for (logFC in logFC_to_iterate){
    wd = paste0(wd, '/logFC-', as.character(logFC))
    dir.create(wd); setwd(wd)
    
    for (min_sets in min_sets_in_coincidence){

      wd2 = paste0(wd, '/n_sets-')
      
      # Pathways related with upregulated genes 
      goUP = enrichGO(gene= data_genes[data_genes$logFC>logFC & data_genes$N.datasets>min_sets-1,]$ENSEMBL,
                      universe = universe_ens,keyType = 'ENSEMBL',
                      OrgDb = organism, readable = TRUE, ont='BP',
                      pvalueCutoff = 0.05, pAdjustMethod = 'BH')
      goUP = goUP@result
      
      simMatrix <- calculateSimMatrix(goUP$ID,
                                      orgdb="org.Hs.eg.db",
                                      ont="BP",
                                      method="Rel")
      scores <- setNames(-log10(goUP$p.adjust), goUP$ID)
      reducedTerms <- reduceSimMatrix(simMatrix,
                                      scores,
                                      threshold=0.7,
                                      orgdb=organism)
      
      goUP$updownregulated = replicate(nrow(goUP), 'UP')
      goUP = goUP[goUP$Description %in% unique(reducedTerms$parentTerm),]
      
      
      # Pathways related with downregulated genes 
      goDOWN = enrichGO(gene= data_genes[data_genes$logFC< -logFC & data_genes$N.datasets>min_sets-1,]$ENSEMBL,
                      universe = universe_ens,keyType = 'ENSEMBL',
                      OrgDb = organism, readable = TRUE, ont='BP',
                      pvalueCutoff = 0.05, pAdjustMethod = 'BH')
      
      goDOWN = goDOWN@result
      
      simMatrix <- calculateSimMatrix(goDOWN$ID,
                                      orgdb="org.Hs.eg.db",
                                      ont="BP",
                                      method="Rel")
      scores <- setNames(-log10(goDOWN$p.adjust), goDOWN$ID)
      reducedTerms <- reduceSimMatrix(simMatrix,
                                      scores,
                                      threshold=0.7,
                                      orgdb=organism)
      
      goDOWN$updownregulated = replicate(nrow(goDOWN), 'DOWN')
      goDOWN = goDOWN[goDOWN$Description %in% unique(reducedTerms$parentTerm),]
      
      # Bind information
      go = rbind(goUP, goDOWN)
      # Consider proportion of genes as numeric
      n_genes_eval_UP = strsplit(go[go$updownregulated=='UP',]$GeneRatio,split='/')[[1]][2]
      n_genes_eval_DOWN = strsplit(go[go$updownregulated=='DOWN',]$GeneRatio,split='/')[[1]][2]
      
      go[go$updownregulated=='UP',]$GeneRatio = as.numeric(round(100*(go[go$updownregulated=='UP',]$Count/as.numeric(n_genes_eval_UP)),1))
      go[go$updownregulated=='DOWN',]$GeneRatio = as.numeric(round(100*(-go[go$updownregulated=='DOWN',]$Count/as.numeric(n_genes_eval_DOWN)),1))
      go$GeneRatio = as.numeric(go$GeneRatio); go = go[order(go$GeneRatio),]
      
      # Store relevant information of GO enriched pathways
      write.csv(x=rbind(goUP, goDOWN), file=paste0('goUP-DOWN_', as.character(p.adj), 'FC', as.character(FC), 'sets', as.character(min_sets)))
      
      # Visualize the data
      if (nrow(go)>20){
        go = go[c(1:10, (nrow(go)-10):nrow(go)),]
      }
      png(file = paste0('Pathways-GO_padj-', as.character(p.adj), '_logFC-', as.character(logFC), '_nsets-', as.character(min_sets)), height=500, width = 520)
      print(ggplot(go, aes(x=reorder(Description, GeneRatio), y=GeneRatio, fill=p.adjust))+
              geom_bar(stat='identity', alpha=.8,width=.345)+
              coord_flip(ylim = c(round(min(go$GeneRatio))-1,round(max(go$GeneRatio))+1))+
              ggtitle(paste0('GO enrich: ', project_name))+ 
              theme_minimal(base_line_size = 0.2)+
              theme(plot.title=element_text(size=18, hjust=0.1, vjust=1.4, family = 'Times'), 
                    axis.title = element_text(size=9, family = 'Times'),
                    axis.text = element_text(size=10.5),
                    axis.text.y = element_text(size=6.5),
                    legend.position = c(0.85, 0.3),
                    legend.title=element_text(size=11.5, family = 'Times', hjust = 0.4, vjust=1.9),
                    legend.background=element_rect(size=0.5, linetype='solid', color='black'),
                    legend.text = element_text(size=8, vjust=0.45))+
              xlab('')+ylab('% genes de la ruta detectados')+
              scale_fill_gradient(name='P valor ajustado', low='magenta', high='darkslateblue', limits=c(0,0.2), breaks=c(0,0.1,0.2)))
      dev.off()
      
    }
  }

    
