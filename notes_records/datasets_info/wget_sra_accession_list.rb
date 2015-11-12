#!/usr/bin/ruby
# encoding: utf-8
#

mainurl = "ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra"
# SRR/SRR304/SRR304976/SRR304976.sra

file = File.open(ARGV[0], "r")
file.each do |line|
	next if line =~ /^#/
	accession = line.chomp.split("\t")
	prefix1 = /^\w{3}/.match(accession[0])
	prefix2 = /^\w{3}\d{3}/.match(accession[0])
	targeturl = [mainurl, prefix1, prefix2, accession[0], accession[0]].join('/') + ".sra"
	#warn "#{targeturl}"
	%x[wget #{targeturl}]
end

