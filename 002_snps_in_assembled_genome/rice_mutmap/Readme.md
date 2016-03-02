### Mutmap rice ems mutagenesis data

The data is described by [Abe et al 2012](http://www.nature.com/nbt/journal/v30/n2/abs/nbt.2095.html)

Sequencing data for the mutants studied in above report are [availabe from SRA] (http://www.ncbi.nlm.nih.gov/sra?term=DRA000499)

Hitomebore reference sequence used in the Mutmap is available [from NCBI Bio project] (http://www.ncbi.nlm.nih.gov/bioproject/PRJDA67163)

Paired-end 75 bp reads were mapped to Oryza sativa cv. "Nipponbare" reference genome (IRGSP build 5).
The genomic regions covered with at least two reads were called as contigs.
SNPs but not indels have been reflected to the consensus contigs.

From [MutMap+ study] (http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0068529) and [MutMap for salt tolreance] (http://www.nature.com/nbt/journal/v33/n5/full/nbt.3188.html) it appears that hitomebore genome sequencing data is [submitted at SRA](http://www.ncbi.nlm.nih.gov/sra/DRA000927)

#### Hit5814 data

Hit5814-sd data is downloaded from accession number DRR001790.

Hitomebore reads downloaded from accession number
DRR004451

Variants were called for Hit5814 and wildtype using Hitomebore scaffolds.

#### Mutation lines and the possible causative mutaion identified by Abe et al. (2012)

| Mutant lines | Chromosome coordinate | Reference base | Altered base | Type of mutation                | Gene annotation and note                                   |
|--------------|-----------------------|----------------|--------------|---------------------------------|------------------------------------------------------------|
| Hit1917-pl1  | chr10: 22981826       | C              | T            | Missense (L to F)               | Chlorophyllide a oxygenase (Os10t0567400)                  |
| Hit1917-pl1  | chr10: 23202531       | C              | T            | Missense (A to V)               | RING-type domain containing protein (Os10t0572500)         |
| Hit0813-pl2  | Not identified        | -              | -            | -                               | No SNPs causing amino acid changes                         |
| Hit1917-sd   | chr12: 23426603       | G              | A            | Mutation at a splicing junction | Succinyl-CoA synthetase-like (Os12t0572800)                |
| Hit0746-sd   | chr8: 27726540        | G              | A            | Missense (V to M)               | Conserved hypothetical protein (Os08t0551200)              |
| Hit5500-sd   | chr9: 20768178        | T              | A            | Nonsense (L to *)               | Cdc48-like protein (Os09t0515100)                          |
| Hit5814-sd   | chr4: 24054530        | A              | T            | Nonsense (R to *)               | Similar to H0418A01.7 protein (Os04t0471400)               |
| Hit5814-sd   | chr4: 24534915        | A              | T            | Missense (E to V)               | Leucine-rich repeat-containing protein (Os04t0480500)      |
| Hit5814-sd   | chr4: 25169073        | C              | T            | Missense (L to F)               | Conserved hypothetical protein (Os04t0493300)              |
| Hit5814-sd   | chr4: 26036923        | C              | T            | Missense (R to C)               | RNA helicase-like protein (Os04t0510400)                   |
| Hit5243-sm   | chr8: 7491119         | C              | T            | Missense (A to V)               | EMBRYO DEFECTIVE 1135 (Os08t0223700)                       |
| Hit5243-sm   | chr8: 11640598        | C              | T            | Missense (R to C)               | Pentatricopeptide repeat containing protein (Os08t0290000) |
| Hit5243-sm   | chr8: 12545030        | T              | A            | Missense (I to N)               | Peroxidase 40 precursor-like protein (Os08t0302000)        |



#### Fragmented rice genome and location of cuasative mutation

Rice Hitomebore corrected scaffolds from Abe et al study is used to generate randomly fragmented genome to mimic genome assembly. Exponential model applied based on the published assemblies of three genomes of Oryza sativa by [Schatz et al 2014](http://www.genomebiology.com/2014/15/11/506).

For more information on the model comparison of the assemblies data and generated random fragment sizes information is available at [genome_frag_lengths_report](../genome_frag_lengths/genome_frag_lengths_report.html)

Resulting genome fragments are randomly shuffled and used for variant calling with Hit5814 data and Hitomebore wildtype data (1 lane of sequencing data).

Resulting mpileup and bam files for both mutant and wildtype are used to pick the location hosting the causative mutation.
data comparison plot is availble in the [mutation_hit5814 folder] (./mutation_hit5814/)

According to above table Hit5814 mutation is located between 24054530 and 26036923 on Chr 4

Rice chormosome sizes

| Chr | Size     |
|-----|----------|
| 1   | 45037867 |
| 2   | 36769206 |
| 3   | 37311027 |
| 4   | 36039975 |
| 5   | 30067358 |
| 6   | 32103480 |
| 7   | 30342941 |
| 8   | 28524352 |
| 9   | 23894718 |
| 10  | 23676002 |
| 11  | 31217802 |
| 12  | 27641879 |

So Causative mutation for Hit5814 lines is between 143,172,630 and 145,155,023, if the genome is ordered from Chr 1 to Chr 12.

And [compare_outcome.pdf] (./mutation_hit5814/compare_outcome.pdf) clearly show are major variants around this position.



