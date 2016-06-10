### Assembling Arabidopsis genome to test Cheripic

#### Assembly

1. De-novo assembly of paired end seqeunce reads for mir159a were used from  [Allen et al](http://journal.frontiersin.org/article/10.3389/fpls.2013.00362/full)

2. Genome assembly carried out using Soapdenovo Version 2.04 using multi-kmer approach

	```
	source soapdenovo2-2.40; SOAPdenovo-127mer all -K 25 -d 1 -R -M 1 -m 95 -E -F -s sample.config -o mir159_multikmer
	```

3. Assembly log file and associated scripts are available in the assembly folder

4. Assembled [contigs](http://www.mediafire.com/download/bj5f2x1yk7ikfaj/mir159_multikmer.contig.fa.gz) and [scaffolds](http://www.mediafire.com/download/mn472azrxfiz65x/mir159_multikmer.scafSeq.fa.gz) files are available to download and md5sums for the files

		c8ff60099b23db738ba87e36a84863c7  mir159_multikmer.contig.fa.gz
		2782d7652da891711c96707307dc3933  mir159_multikmer.scafSeq.fa.gz


5. [count\_fasta.pl] (../../../lib/count_fasta.pl) output of sequence lengths and N50 stats for all scaffolds

		Total length of sequence:	151871645 bp
		Total number of sequences:	287909
		N25 stats:			25% of total sequence length is contained in the 845 sequences >= 30065 bp
		N50 stats:			50% of total sequence length is contained in the 2712 sequences >= 13865 bp
		N75 stats:			75% of total sequence length is contained in the 11119 sequences >= 919 bp
		Total GC count:			56224372 bp
		GC %:				37.02 %
		
complete lengths and details are [available here](./scaffolds_all_lengths_summary.txt)

 
6. [select\_fasta.rb] (../../../lib/select_fasta.rb) script used to discard scaffold sequences less than 300bp 

7. [Selected scaffolds] (http://www.mediafire.com/download/p1t7x3xj80719dq/scaffolds_mir159_multikmer_300bp.fa.gz) file is available to download and md5sum of the file

		be0c3485a2cf621c13ec836fd3523441  scaffolds_mir159_multikmer_300bp.fa.gz


6. sequence lengths and N50 stats for selected (>= 300bp) scaffolds

		Total length of sequence:	117607777 bp
		Total number of sequences:	18267
		N25 stats:			25% of total sequence length is contained in the 583 sequences >= 35373 bp
		N50 stats:			50% of total sequence length is contained in the 1690 sequences >= 20323 bp
		N75 stats:			75% of total sequence length is contained in the 3769 sequences >= 9607 bp
		Total GC count:			42230420 bp
		GC %:				35.91 %
		
complete lengths and details are [available here](./scaffolds_300bp_lengths_summary.txt)
