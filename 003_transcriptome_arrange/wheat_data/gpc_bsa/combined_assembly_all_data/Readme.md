## Combined assembly of wheat transcriptome

Wheat transcriptome is assembled using short read sequence data is available at the Sequence Read Archive (SRA) under the accession code ERA050658. 
And details about the sample ids and description are in [the following text file] (../../notes_records/datasets_info/gpc_wheat_trick_bmcpb_2012.txt)


Trimmomatic filtered reads for all 4 libraries (LDN, RSL65, high and low gpc bulks with two different insert sizes of 250bp and 400bp each) were used in assembly

soapdenovo_trans-1.03 is used for assembly, by employing assembly with
different k-mer lengths - 25, 31, 41, 51, 61, 71, 81, 91 and 101

Assembly script, config and output log files are proided here
[shell script](./log_files/1_soap-trans_kmer_iter.sh)
[config file](./log_files/2_sample.config)
[assembly_contig_log](./log_files/3_log_soap_trans_kmer_iter.txt)

Assembled contig files are [available here](https://www.mediafire.com/folder/k3vdgpkdtehmb/k_mer_contigs)

Number of sequences assembled at each k-mer
```
filename					number
trans_assem_25.contig	858928
trans_assem_31.contig	644590
trans_assem_41.contig	440643
trans_assem_51.contig	328002
trans_assem_61.contig	231567
trans_assem_71.contig	155594
trans_assem_81.contig	102939
trans_assem_91.contig	67367
trans_assem_101.contig	36554
```

Using `fasta_pooled_changename.rb` script in lib folder of this repo
grater than equal to 100bp contigs are pooled and used for downstream analysis

```ruby fasta_pooled_changename.rb contig 100 > selected_kmer_contigs.fa```

number of sequences in selected_kmer_contigs.fa `2141085`

Pooled contigs were analysed using transrate vs 1.0.1

```source transrate-1.0.1; transrate --assembly selected_kmer_contigs.fa --left pr_ERR045179_1.fq.gz,pr_ERR045180_1.fq.gz,pr_ERR045181_1.fq.gz,pr_ERR045182_1.fq.gz,pr_ERR045183_1.fq.gz,pr_ERR063461_1.fq.gz --right pr_ERR045179_2.fq.gz,pr_ERR045180_2.fq.gz,pr_ERR045181_2.fq.gz,pr_ERR045182_2.fq.gz,pr_ERR045183_2.fq.gz,pr_ERR063461_2.fq.gz --threads 32 > analysis_log_transrate.txt```

log files from transrate analysis are provided here
[analysis log](./log_files/4_analysis_log_transrate.txt)
[transrate summary](./log_files/5_transrate_assemblies.csv)

transrate analysis resulted categorising contigs following categories		
[good contig sequences](http://www.mediafire.com/file/jka7859404stxci/good_contigs_pooled_kmer.fa.gz)		
[bad contig sequences](http://www.mediafire.com/file/y4gun44q9rx72jk/bad.selected_kmer_contigs.fa.gz)		
```
filename							number
bad.selected_kmer_contigs.fa	1598968
good.selected_kmer_contigs.fa	542117
```

resulting good contigs were clustered using cd-hit version 4.6.4

and used -c option from 99.5 to 95.0 in 0.5 decrements

resulted following number of clusters
```
==> cdhit_95.0_log.txt		288036  clusters
==> cdhit_95.5_log.txt		294220  clusters
==> cdhit_96.0_log.txt		301186  clusters
==> cdhit_96.5_log.txt		309209  clusters
==> cdhit_97.0_log.txt		317978  clusters
==> cdhit_97.5_log.txt		327635  clusters
==> cdhit_98.0_log.txt		338415  clusters
==> cdhit_98.5_log.txt		350154  clusters
==> cdhit_99.0_log.txt		362413  clusters
==> cdhit_99.5_log.txt		380779  clusters
```

proceeded with clusers resulting from cd-hit 95% identity for scaffolding


used soap-denovo [prepare v2.0 module for scaffolding](https://sourceforge.net/projects/soapdenovo2/files/Prepare/)
cd-hit reduced contigs are used for scaffolding

```~/programs/prepare/prepare/bin -p 32 -g all_combined -D -c 95.0_good.select_kmer_con.fa```

[mapping and scaffolding log is available here](./log_files/6_soap_map_scaff_log.txt)


resultling scaffolds are clustered using [tgicl v 0.1] (ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/tgicl_linux.tar.gz)

tgicl analysis log is available here
[tgicl log](./log_files/7_err_tgicl_all_combined.scafSeq.log)

results of the tgicl are combined as following
```
*.singletons has ids of all singlets and cdbyank index file to extract sequences

tgicl_linux/bin/cdbyank all_combined.scafSeq.cidx < all_combined.scafSeq.singletons > all_combined.scafSeq_tgicl.fa

asm_*/contigs file has clustered and combined assembled sequences, so add them to tail of your singlets to get
output from tgicl

cat asm_1/contigs >> all_combined.scafSeq_tgicl.fa
```

and resulting file is [available here](http://www.mediafire.com/file/atcjmtbugoyil1b/all_combined.scafSeq_tgicl.fa.gz)


from the all_comb_pooled.scafSeq_tgicl.fa scaffolds file, only sequence grater than equal 200bp are selected as reference
and the file is [available here](http://www.mediafire.com/file/z59cj28z3qxt58g/all_comb_scafs_tgicl_sel.fa.gz)

summary of the assembly details from above file

```
==> all_comb_scafs_tgicl_sel.fa 

Total length of sequence:	85294562 bp
Total number of sequences:	110934
N25 stats:			25% of total sequence length is contained in the 7359 sequences >= 2001 bp
N50 stats:			50% of total sequence length is contained in the 21678 sequences >= 1132 bp
N75 stats:			75% of total sequence length is contained in the 48440 sequences >= 565 bp
Total GC count:			40670578 bp
GC %:				47.68 %


==> all_combined.scafSeq_tgicl.fa

Total length of sequence:	92832693 bp
Total number of sequences:	166556
N25 stats:			25% of total sequence length is contained in the 8325 sequences >= 1898 bp
N50 stats:			50% of total sequence length is contained in the 25195 sequences >= 1015 bp
N75 stats:			75% of total sequence length is contained in the 59642 sequences >= 451 bp
Total GC count:			44144049 bp
GC %:				47.55 %

```

