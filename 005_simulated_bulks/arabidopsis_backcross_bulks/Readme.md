# Generating simulated bulk populations using variants from Arabidopsis backcross

Varints derived of Arabidopsis back-cross bulk data from [Allen et al, 2013] (http://journal.frontiersin.org/article/10.3389/fpls.2013.00362/full) was used as input.

Both homozygous and heterozygous variants only observed in mutant bulk pools are used as markers for simulation of recombinant population.

bulks were simulated using the code provided at [simulate bulk sequences](https://github.com/shyamrallapalli/simulate_bulk_sequence/tree/master/data_analysis/)

example command from the directory with a config file
```
  bsub.rb m-2d 4G "source ruby-2.0.0; source R-3.0.0; ruby ~/lib/bulk_simulator/simulate_f2_pop.rb ."
```

The config files present in following folders		
[bulks\_pure](./bulks_pure)		
[bulks\_one\_mixed](./bulks_one_mixed)		

represent settings used to generate a bulk population with either pure pools or pools with a mis-phenotype in the mutant bulks, respectively.		
20 bulk poulations for each group were generated


		
=========================		
				
					
					
					
Once bulk genome sequences were generated, they were used as input to generate simulated Illumina sequences at 20X depth of coverage using pools of sequeneces as population.


[submit\_gemsim.rb](./submission_scripts/1_submit_gemsim.rb) is used to submit parallel jobs of simulating reads
			
			
			
For each simulated bulk population 10 simulated Illumina seqeucning paired reads of 100bp length were generated.
Resulting in 200 (20 * 10) bulk populatons

		
		
=========================		
				
					
										
Once reads were simulated, parallel jobs of genome assembly were submitted to generate de-novo assemblies from bulk populations generated.
		
[batch\_assemble\_iterations.sh](./submission_scripts/2_batch_assemble_iterations.sh)		


		
=========================		
				
					
										
Generate de-novo assemblies from bulk populations were filetered to select only sequences longer than a given length using following script (used >=300bp in our analysis) 
		
[3\_unzip\_fasta\_write\_selected\_len.rb](./submission_scripts/3_unzip_fasta_write_selected_len.rb)		


		
=========================		
		
		
				
					
										
