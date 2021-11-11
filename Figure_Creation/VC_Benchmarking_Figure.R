library(tidyverse)
library(RColorBrewer)

bench_df<- read.csv("~/Desktop/NoyesLab/Benchmark.csv")
bench_df


###Dataset Fixing
bench_df$Dataset_num<-ifelse(bench_df$Dataset=="M0.5",0.5,
                         ifelse(bench_df$Dataset=="M1",1,
                                ifelse(bench_df$Dataset=="M5",5,
                                       ifelse(bench_df$Dataset=="M10",10,
                                              ifelse(bench_df$Dataset=="M15",15,
                                                     ifelse(bench_df$Dataset=="M25",25,50))))))
bench_df$Dataset_f<-factor(bench_df$Dataset, levels=c("M0.5","M1","M5","M10","M15","M25","M50"))

###Subset Fixing
bench_df$Subset_num<-ifelse(bench_df$Subset=="S5",5,
                            ifelse(bench_df$Subset=="S15",15,
                                   ifelse(bench_df$Subset=="S25",25,35)))
bench_df$Subset<-ifelse(bench_df$Subset=="S5","5 Genomes",
                        ifelse(bench_df$Subset=="S15","15 Genomes",
                               ifelse(bench_df$Subset=="S25","25 Genomes","35 Genomes")))

bench_df$Subset_f<-factor(bench_df$Subset, levels=c("5 Genomes","15 Genomes","25 Genomes","35 Genomes"))


###Variant Caller Fixing
bench_df$VCaller<-ifelse(bench_df$VCaller=="FB_Out","FreeBayes",
                         ifelse(bench_df$VCaller=="GATK_Out","GATK",
                                ifelse(bench_df$VCaller=="Disco_Out","DiscoSNP++","MetaSNV")))
bench_df$VCaller_f<-factor(bench_df$VCaller,levels=c("MetaSNV","GATK","FreeBayes","DiscoSNP++"))




#cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

#cbbPalette <- c("#DC267F","#FE6100","#648FFF","#0072B2")
#cbbPalette <- c("#E03488","#785EF0","#FE6100","#E8B33C")
#display.brewer.all(n = NULL, type = "qual", select = NULL,
                   #colorblindFriendly = TRUE)
cbbPalette<-rev(brewer.pal(n=4,name = "Dark2"))

bench_df[bench_df$Dataset==50,]
bench_df[bench_df$Subset=="5 Genomes",]


#####
#####Subset as FACET
#####

ggplot(bench_df,aes(x=Dataset_num,y=F.score,colour=VCaller_f,group=VCaller_f)) + geom_point() + geom_line() + 
  facet_wrap(~Subset_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Number of Reads (millions)") + ylab("F-Score") + labs(col="Variant Caller") +
  scale_color_manual(values=cbbPalette) + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)), axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)), axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 
  

VC_light_palette<-rev(brewer.pal(n=7,name = "BuGn"))

#RYB version
ggplot(bench_df,aes(x=VCaller_f,y=F.score,fill=Dataset_f,group=Dataset_f)) + 
  geom_col(colour="black",position="dodge2") + facet_wrap(~Subset_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Variant Caller") + ylab("F-Score") + labs(fill="# of Reads (millions)") +
  scale_fill_brewer(palette = "RdPu") + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)),
        axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)),
        axis.text.x = element_text(size=9,angle=70,vjust = 0.6),
        axis.title.y = element_text(face="bold",margin=margin(0,15,0,0)))  

#Dark2 version
ggplot(bench_df,aes(x=VCaller_f,y=F.score,fill=Dataset_f,group=Dataset_f)) + geom_col(colour="black",position="dodge2") + 
  facet_wrap(~Subset_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Variant Caller") + ylab("F-Score") + labs(fill="# of Reads (millions)") +
  scale_fill_manual(values=VCPalette) + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)),
        axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)),
        axis.text.x = element_text(size=9,angle=70,vjust = 0.6),
        axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 




#####
#####Variant Callers as FACET
#####
VCPalette<-rev(brewer.pal(n=7,name = "Dark2"))


ggplot(bench_df,aes(x=Dataset_num,y=F.score,colour=Subset_f,group=Subset_f)) + geom_point() + geom_line() + 
  facet_wrap(~VCaller_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Number of Reads (millions)") + ylab("F-Score") + labs(col="# of Reference Genomes") +
  scale_color_manual(values=cbbPalette) + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)), axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)), axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 


ggplot(bench_df,aes(x=Subset_num,y=F.score,colour=Dataset_f,group=Dataset_f)) + geom_point() + geom_line() + 
  facet_wrap(~VCaller_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Number of Reference Genomes") + ylab("F-Score") + labs(col="Number of Reads (millions)") +
  scale_color_brewer(palette = "RdPu") + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)), axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)), axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 

#Barplot version
ggplot(bench_df,aes(x=Subset_f,y=F.score,fill=Dataset_f,group=Dataset_f)) + geom_col(colour="black",position="dodge2") + 
  facet_wrap(~VCaller_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Number of Reference Genomes") + ylab("F-Score") + labs(col="Number of Reads (millions)") +
  scale_fill_brewer(palette = "RdPu") + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)), axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)), axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 

ggplot(bench_df,aes(x=Subset_f,y=F.score,fill=Dataset_f,group=Dataset_f)) + geom_col(colour="black",position="dodge2") + 
  facet_wrap(~VCaller_f,nrow=2) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Number of Reference Genomes") + ylab("F-Score") + labs(col="Number of Reads (millions)") +
  scale_fill_manual( values=rev(brewer.pal(n=7,name = "BuGn")) ) + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)), axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)), axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 




#####
#####Dataset as FACET
#####

ggplot(bench_df,aes(x=Subset_num,y=F.score,colour=VCaller_f,group=VCaller_f)) + geom_point() + geom_line() + 
  facet_wrap(~Dataset_f,nrow=1) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Number of Reference Genomes") + ylab("F-Score") + labs(col="Variant Caller") +
  scale_color_manual(values=cbbPalette) + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)), axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)), axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 



ggplot(bench_df,aes(x=VCaller_f,y=F.score,fill=Subset_f,group=Subset_f)) + geom_col(colour="black",position="dodge2") + 
  facet_wrap(~Dataset_f,nrow=1) +
  ggtitle("Variant Caller Accuracy by Number of Reads\n and Reference Genomes") +
  xlab("Variant Caller") + ylab("F-Score") + labs(col="# of Reference Genomes") +
  scale_fill_brewer(palette = "RdPu") + theme_bw() +
  theme(plot.title = element_text(hjust=0.5,size=13,face="bold",margin=margin(0,0,15,0)),
        axis.title.x = element_text(face="bold",margin=margin(15,0,0,0)),
        axis.text.x = element_text(size=9,angle=70,vjust = 0.6),
        axis.title.y = element_text(face="bold",margin=margin(0,15,0,0))) 
