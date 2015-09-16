### Testing SDM on assembled Arabidopsis genome

#### Assembly

1. De-novo assembly of Single end seqeunce reads for Col-T were used from [Uchida et al] (http://pcp.oxfordjournals.org/content/52/4/716.long) for Uni-1D mutant

2. Genome assembly carried out using SPAdes version: 3.1.0

3. Resulting scaffolds file `uni-1d_col_spades_scaffolds.fasta` and spades log is available under assembly folder

4. A perl script count_fasta.pl is used from [http://wiki.bioinformatics.ucdavis.edu/index.php/Count_fasta.pl](http://wiki.bioinformatics.ucdavis.edu/index.php/Count_fasta.pl) to get sequence lengths and N50 stats

Total length of sequence:	111544374 bp
Total number of sequences:	150004
N25 stats:			25% of total sequence length is contained in the 2987 sequences >= 6349 bp
N50 stats:			50% of total sequence length is contained in the 9054 sequences >= 3423 bp
N75 stats:			75% of total sequence length is contained in the 21629 sequences >= 1401 bp
Total GC count:			40617457 bp
GC %:				36.41 %
 
5. Majority of the assembled sequences were small, so used `select_fasta.rb` script to discard sequences less than 500bp and saved sequnces to `uni-1d_col_spades_scaff_500bp.fasta`

6. 111376 discarded and N50 stats are as following
Total length of sequence:	98441637 bp
Total number of sequences:	38628
N25 stats:			25% of total sequence length is contained in the 2490 sequences >= 6854 bp
N50 stats:			50% of total sequence length is contained in the 7279 sequences >= 3977 bp
N75 stats:			75% of total sequence length is contained in the 15852 sequences >= 2052 bp
Total GC count:			35617429 bp
GC %:				36.18 %

