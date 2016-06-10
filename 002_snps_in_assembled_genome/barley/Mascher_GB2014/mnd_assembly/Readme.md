### Barley _mnd_ mutant exome seqeuncing

The _many-noded dwarf_ (_mnd_) exome data is described by [Mascher and Jost et al 2014](http://genomebiology.biomedcentral.com/articles/10.1186/gb-2014-15-6-r78)

X-ray mutagenesis of barley cv. Saale, identified _mnd_. F2 population was developed by crossing _mnd_ to barley cv. Barke. DNA from 18 mutant and 30 wildtype plants from F2 population were randomly selected and bulk sequenced.
Paired-end 100 bp reads sequenced and data is available to [download from SRA] (http://www.ncbi.nlm.nih.gov/bioproject/PRJEB5319/)

[mutant_pool] (http://www.ncbi.nlm.nih.gov/biosample/2796289)

[wildtype_pool] (http://www.ncbi.nlm.nih.gov/biosample/2796290)

#### Exome assembly

wildtype pool data is used to assemble the exome of barley

spades 3.6.0 is used for assembly

assembly inputs and assembly log are [available in following directory] (./spades_assembly_info)

assembled contigs can be [downloaded from this link] (http://www.mediafire.com/download/4z5aq7k2052lgoz/barley_mnd_exome_spades_contigs.fa.gz)

* info about assembled contigs

```
Total length of sequence:	261071484 bp
Total number of sequences:	845075
N25 stats:			25% of total sequence length is contained in the 26556 sequences >= 1460 bp
N50 stats:			50% of total sequence length is contained in the 100612 sequences >= 577 bp
N75 stats:			75% of total sequence length is contained in the 289414 sequences >= 240 bp
Total GC count:			125710325 bp
GC %:				48.15 %
longest contig size: 26199
```


assembled scaffolds can be [downloaded from this link] (http://www.mediafire.com/download/5y026dl87w49l68/barley_mnd_exome_spades_scaff.fa.gz)

* info about assembled scaffolds

```
Total length of sequence:	261266285 bp
Total number of sequences:	844731
N25 stats:			25% of total sequence length is contained in the 26355 sequences >= 1467 bp
N50 stats:			50% of total sequence length is contained in the 100256 sequences >= 578 bp
N75 stats:			75% of total sequence length is contained in the 288881 sequences >= 240 bp
Total GC count:			125796094 bp
GC %:				48.15 %
longest scaffold size: 26199
```


assembled scaffolds are subjected to quality control analysis using transrate software (v1.0.1)

Transrate is designed to evaluate transcriptome assembly.
However, as the assembly is of exome capture and transrate primarily calculates contig/scaffold metric based on read support; this analysis was applied.

results of the transcrate analysis log is [available here] (./spades_assembly_info/transrate_analysis_log.txt)
and assembly report is [available here] (./spades_assembly_info/transrate_assemblies.csv)

scaffolds marked as good by tranrate are used for downstream analysis
and [the selected scaffolds are available here] (http://www.mediafire.com/download/2z9h2vq64oho7mo/barley_mnd_exome_spades_scaff_transrate_good.fa.gz)

* info about good scaffolds selected by transrate

```
Total length of sequence:	150629182 bp
Total number of sequences:	216972
N25 stats:			25% of total sequence length is contained in the 11362 sequences >= 2216 bp
N50 stats:			50% of total sequence length is contained in the 35928 sequences >= 1105 bp
N75 stats:			75% of total sequence length is contained in the 86898 sequences >= 501 bp
Total GC count:			72461375 bp
GC %:				48.11 %
```


Transrate selected scaffolds are further filtered by discarding fragments less than 300bp length.
Length selected and transrate [filtered assembly is available here] (http://www.mediafire.com/download/ljqjj8iw6b7jq4j/barley_mnd_exome_spades_scaff_transrate_good_select.fa.gz)

* info about length selected good scaffolds selected by transrate

```
Total length of sequence:	132213141 bp
Total number of sequences:	137265
N25 stats:			25% of total sequence length is contained in the 9371 sequences >= 2414 bp
N50 stats:			50% of total sequence length is contained in the 28271 sequences >= 1312 bp
N75 stats:			75% of total sequence length is contained in the 63399 sequences >= 687 bp
Total GC count:			63433883 bp
GC %:				47.98 %
```

