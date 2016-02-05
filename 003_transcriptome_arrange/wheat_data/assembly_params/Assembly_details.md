Assembly RNA-seq data for wheat data

using soapdenovo-trans

using trimmomatic data from both parents and both bulks

and using various k-mer sizes are used

sample config and shell script for assembly are included.

For assembly only pregraph and contigs are made 

Resulting contigs are from all kmers are subject to transrate analysis using the reads used for contigs

Good rated contigs selected with default parameter of transrate are pooled from all kmers and contig seqeunces smaller than 100bp are discarded.

cd-hit-est is used to reduce the redundancy and contigs with 95% perecent identify or more are discarded by keeping the longest sequence.

Resulting contig sequences are prepared for scaffoling using provided prepare binaries
include link for the binary

map and scaffold part of assembly are continued using the cdhit reduced contigs.

Resulting scaffolds are subjected to tgicl for clustering sequencing and assembly to longer transcripts.

include tgicl options