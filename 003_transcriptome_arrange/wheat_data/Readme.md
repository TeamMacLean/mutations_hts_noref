## Arrngement of gene space using variant information for causative mutation location

### Data background

Parents

* LDN - langdon (no functional grain protein content GPC-B1 allele)
* RSL65 - a recombinat substitution line carrying functional GPC-B1 allele in a 30cM region from Chromosome 6B fragment from wild emmer. And RSL65 should be isogenic to LDN outside this interval.


Cross between LDN and RSL65 resulted in F2 population, producing segregants and pooled bulks of high and low gpc content were sequencd and used variant analysis and identification of region carrying the functional GPC-B1 allele. 

* 14 high gpc phenotype progeny are bulked 
* 13 low gpc phenotype progency are bulked (two individual RNAs were mixed twice) so makes 15 samples in bulk

These two bulks carry variants resulting from 30cM region in Chromosome 6B that are segregating between both bulks. More detail on the study are available [in the manuscript] (http://bmcplantbiol.biomedcentral.com/articles/10.1186/1471-2229-12-14)

Short read sequence data is available at the Sequence Read Archive (SRA) under the accession code ERA050658. And details about the sample ids and description are [in the following text file] (../../notes_records/datasets_info/gpc_wheat_trick_bmcpb_2012.txt)



### Methods

#### read filtering

fastqc analysis (```source fastqc-0.11.3; fastqc input-fastq-file```)
report for ldn wildtype paired reads is [available here](./gpc_bsa/fastqc_reports/langdon)
fastqc reports show that there are poor quality bases at 3' end of reads and truseq adapter sequences at 3' end of most reads. So reads were quality filtered and trimmed using trimmomatic software ver 0.33

``` source trimmomatic-0.33; trimmomatic PE ERR045179_1.fastq.gz ERR045179_2.fastq.gz ERR045179_1.paired.fq.gz ERR045179_1.nopair.fq.gz ERR045179_2.paired.fq.gz ERR045179_2.nopair.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50 ```

fastqc report for reports for trimmed reads is [available here](./gpc_bsa/fastqc_reports/langdon/trimmomatic)

In addition to testing trimmomatic for quality filtering and trimming
i have used two step quality filtering using fastx toolkit and trimmed reads using trimmomatic

paired reads are put together using python scripts in khmer package ver 2.0

``` source khmer-2.0; interleave-reads.py ERR045179_1.fq ERR045179_2.fq | gzip -9c > ERR045179_pe.fq.gz ```

pooled reads are filtered using fastq_quality_filter from fastx toolkit 

``` source fastx-0.0.13; gzip -dc ERR045179.pe.fq.gz | fastq_quality_filter -Q33 -q 30 -p 50 | gzip -9c > ERR045179.qc.fq.gz ```

quality filtered reads are seperated to paired and singletons uisng khmer scripts

```source khmer-2.0; extract-paired-reads.py ERR045179.pe.qc.fq.gz```

Resulting paired reads are adapter tirmmed using trimmomatic

```source trimmomatic-0.33; trimmomatic PE ERR045179.fastx_qc.pe.1.fq.gz ERR045179.fastx_qc.pe.2.fq.gz ERR045179.fastx_qc.pe.1.paired.fq.gz ERR045179.fastx_qc.pe.1.nopair.fq.gz ERR045179.fastx_qc.pe.2.paired.fq.gz ERR045179.fastx_qc.pe.2.nopair.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50```

fastqc report for reports for filtered and trimmed reads is [available here](./gpc_bsa/fastqc_reports/langdon/fastx_quality_timmo)


fastqc analysis report for ldn wildtype paired reads is [available here](./gpc_bsa/fastqc_reports/rsl65)


```source trimmomatic-0.33; trimmomatic PE ERR045180_1.fastq.gz ERR045180_2.fastq.gz ERR045180_1.PR.fq.gz ERR045180_1.UP.fq.gz ERR045180_2.PR.fq.gz ERR045180_2.UP.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50```

fastqc report for reports for trimmed reads is [available here](./gpc_bsa/fastqc_reports/rsl65/trimmo)

similary fastqc reports for high and low GPC bulks are available at the following links with sub-direcotries for libraries made with 250bp and 400bp insert

[high GPC bulk](./gpc_bsa/fastqc_reports/highgpc_bulk)		
[low GPC bulk](./gpc_bsa/fastqc_reports/lowgpc_bulk)

#### transcriptome assembly

assembly using soapdenovo_trans (ver 1.03) and trinity

soapdenovo_trans assembly was carried out using at different k-mer lengths, while trinity assembly carried out using 25 kmer
soap sample config and shell script to run multiple k-mer assemblies are at following links		
[soap-trans\_kmer\_iter.sh](./assembly_params/soap-trans_kmer_iter.sh)		
[sample.config](./assembly_params/sample.config)

assmebly log for trinity for both parents are available at following links		
[trinity\_log\_langdon.txt](./assembly_params/trinity_log_langdon.txt)		
[trinity\_log\_rsl65.txt](./assembly_params/trinity_log_rsl65.txt)

Assemblies were compared using transrate software using the same reads used for assembly

Based on the assembly score and the number contigs and mean contigs and N50 values trinity assembly has scored better than rest of the soapdenovo_trans assemblies

Transrate submission

```source transrate-1.0.1; transrate --assembly assembly31.scafSeq,assembly41.scafSeq,assembly51.scafSeq,assembly61.scafSeq,assembly71.scafSeq,assembly91.scafSeq,assembly101.scafSeq --left ERR045180_1.PR.fq.gz --right ERR045180_2.PR.fq.gz --threads 32```


* modifying fasta ids resulting from trinity

typical naming in trinity fasta outcome

```
>TR1|c0_g1_i1 len=491 path=[11119:0-334 11504:335-380 11617:381-381 11562:382-384 11496:385-398 11610:399-399 11554:400-455 11491:456-489 11235:490-490] [-1, 11119, 11504, 11617, 11562, 11496, 11610, 11554, 11491, 11235, -2]
AGCCCCACTCCCACCAGCATCTCCTTCTGCCGCCGCCGCCGCCTAACTCTCTCCCTGTGC
```

used following  sed commands to remove '|' and path information in names

```
sed 's/|/_/' trinity_out_dir.Trinity.fasta > trinity_out_temp.fa
sed 's/\spath=.*$//' trinity_out_temp.fa > trinity_out_fixed.fa

```

resulting fasta id's look as follows

```
>TR1_c0_g1_i1 len=491
AGCCCCACTCCCACCAGCATCTCCTTCTGCCGCCGCCGCCGCCTAACTCTCTCCCTGTGC
```


transrate provides a selected sequences with good read evidence as good quality contigs.
good quality selected trinity assemblies were selected for downstream analysis

These selected trinity contigs were used to generate homeologus gene sequences using [homeosplitter software](http://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-14-S15-S15)

It takes alr file derived form bam and an indexed fasta file as inputs to generate homelogus gene calls

Reads used for assembly were aligned to the trinity selected contigs and the bam file is converted to alr 
using [bam2alr software](http://kimura.univ-montp2.fr/calcul_isem.wp/isem-softwares/logiciels/)


cd-hit-est software was used to reduce the redundancy 


```

grep -c ">" output.fasta
84531

grep -c ">" cdhit100_homeosplit.fa
84527

grep -c ">" cdhit99.5_homeosplit.fa
84449


grep -c ">" good.trinity_out_fixed.fa
66044

grep -c ">" 99_cdhit/cdhit99_good.trinity.fa
64362

grep -c ">" cdhit99.5_good.trinity.fa
65388

grep -c ">" 100_cdhit/cdhit_good.trinity.fa
66027


```

#### variant calling

Align low and high gpc bulks to assembly of LDN
substract variants common between both from high gpc bulk

align reads from rsl65 to assembly of LDN
keep common variants between rsl65 and selected high gpc bulk
and use resulting variants for analysis



