### Hitomebore genome assembly

#### Input data

Hitomebore reference sequence used in the Mutmap is available [from NCBI Bio project] (http://www.ncbi.nlm.nih.gov/bioproject/PRJDA67163)

From [MutMap+ study] (http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0068529) and [MutMap for salt tolreance] (http://www.nature.com/nbt/journal/v33/n5/full/nbt.3188.html) it appears that hitomebore genome sequencing data is [submitted at SRA](http://www.ncbi.nlm.nih.gov/sra/DRA000927)

Hitomebore three runs of reads downloaded from accession number DRR004451,DRR004452 and DRR004453  from above link


#### Read preparation

Downloaded reads qualities are analyzied by fastqc and reports are available 
in the following folders
[reports of raw reads](./fastqc_reports/raw_reads)
reads seems to have few issues on 5' end base distribution, 
few kmer enirchment and drop in qualtiy at 3' end 
some enrichment in ambiguous base reads

Reads are processed using trimmomatic v 0.33 
log files, adapter information and fastqc reports of Output read pairs are 
[available here](./fastqc_reports/trimmomatic_processed)

#### Assembly

Multi kmer assembly of rice hitomebore reads is carried out
sample config file, shell script running multiple kmer assembly and the log from contig assembly 
are included in [soapdenovo_logs folder](./soapdenovo_logs)

