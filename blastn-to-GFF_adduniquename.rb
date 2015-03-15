#!/usr/bin/ruby
# encoding: utf-8
#
require 'bio'

def return_aln_parameters_query (hash)
	data = Hash.new {|h,k| h[k] = {} }
	hash.each { |a,b|
		hash[a].each { |c, d|
			array = c.split("\t") 
			if data[a].key?("alnlength") == true
				data[a]["alnlength"] = array[3].to_i + data[a]["alnlength"]
			else
				data[a]["alnlength"] = array[3].to_i
			end
			if data[a].key?("mismatch") == true
				data[a]["mismatch"] = array[4].to_i + data[a]["mismatch"]
			else
				data[a]["mismatch"] = array[4].to_i
			end
			if data[a].key?("gap") == true
				data[a]["gap"] = array[5].to_i + data[a]["gap"]
			else
				data[a]["gap"] = array[5].to_i
			end
		}
	}
	data
end

def return_best_contig_aln (hash2)
	contigid = ""
	hash2.each { |key, value|
		if contigid =~ /\w/
			if hash2[key]["alnlength"] > hash2[contigid]["alnlength"] && hash2[key]["mismatch"] < hash2[contigid]["mismatch"] && hash2[key]["gap"] < hash2[contigid]["gap"]
				contigid = key
			elsif hash2[key]["alnlength"] == hash2[contigid]["alnlength"] && hash2[key]["mismatch"] == hash2[contigid]["mismatch"] && hash2[key]["gap"] == hash2[contigid]["gap"]
				contigid = ""
			end
		else
			contigid = key
		end
	}
	contigid
end


blast = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] ={} } }
genes = Hash.new {|h,k| h[k] = {} }

file = Bio::FastaFormat.open(ARGV[0])
file.each do |entry|
	genes[entry.entry_id] = entry.length
end
  
lines = File.read(ARGV[1])
results = lines.split("\n")
results.each do |string|
  if string !~ /^#/ 
	blastdata = string.split("\t")

#=begin
	geneid = ""
	if blastdata[0] =~ /^CHAFR/
		blast[blastdata[0]][blastdata[1]][string] = 1
	end
  end
#=end
	
=begin
	blast[blastdata[0]][blastdata[1]][string] = 1
#			qurey id	subject id	  blast-data
  end

# => # Query: comp100013_c0_seq1 len=202 path=[180:0-201]
  if string =~ /^#\sQuery:\s(\w+)\slen=/
	geneid = $1
	if string =~ /^#\sQuery:\s\w+\slen=(\d*)\s/
		genes[geneid] = $1
	end

# => # Query: comp12918_c0_seq1 FPKM_all:2.679_FPKM_rel:2.679 len:364 path:[0]
  elsif string =~ /^#\sQuery:\s(\w+)\sFPKM\_all:/
	geneid = $1
	if string =~ /^#\sQuery:\s\w+\s\S+\slen:(\d*)\s/
		genes[geneid] = $1
	end
  end
=end
end

#gff = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] ={} } } }
gff = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) } ## vivified hash

blast.each { |k1,v1|

  data2 = return_aln_parameters_query(blast[k1])
  subjectid = return_best_contig_aln(data2)

  if subjectid =~ /\w/
	genelen_cov = (100* data2[subjectid]["alnlength"].to_i)/genes[k1].to_i
	mismatch_cov = (100* data2[subjectid]["mismatch"].to_i)/genes[k1].to_i
	if genelen_cov >= 80 and mismatch_cov <=10
		limits = Hash.new {|h,k| h[k] = {} }
		contignum = ""
		if subjectid =~ /\_(\d+)$/
			contignum = $1.chomp.to_i
#			puts contignum
		end

		blast[k1][subjectid].each { |key2, value2|
			array2 = key2.split("\t")
			aln_end = array2[9].to_i
			aln_start = array2[8].to_i
#			puts "#{k1}\t#{aln_end}\t#{aln_start}\n"
			if aln_end < aln_start
#				outfile.puts "#{subjectid}\tTRINITY\texon\t#{aln_end}\t#{aln_start}\t.\t-\t.\tParent=#{k1};Target=#{k1} #{array2[6].to_i} #{array2[7].to_i}\n"
				info = "#{subjectid}\tTRINITY\texon\t#{aln_end}\t#{aln_start}\t.\t-\t.\tParent=#{k1};Target=#{k1} #{array2[7].to_i} #{array2[6].to_i};Genelength=#{genes[k1]}".to_s
				gff[contignum][subjectid][aln_end][k1][:exon][info] = 1
				limits[:strand] = "-"
				if limits.key?(:start) == true
					if limits[:start] > aln_end
						limits[:start] = aln_end
					end
				else
					limits[:start] = aln_end
				end
				if limits.key?(:stop) == true
					if limits[:stop] < aln_start
						limits[:stop] = aln_start
					end
				else
					limits[:stop] = aln_start
				end
			elsif aln_end > aln_start
#				outfile.puts "#{subjectid}\tTRINITY\texon\t#{aln_start}\t#{aln_end}\t.\t+\t.\tParent=#{k1};Target=#{k1} #{array2[6].to_i} #{array2[7].to_i}\n"
				info = "#{subjectid}\tTRINITY\texon\t#{aln_start}\t#{aln_end}\t.\t+\t.\tParent=#{k1};Target=#{k1} #{array2[6].to_i} #{array2[7].to_i};Genelength=#{genes[k1]}".to_s
				gff[contignum][subjectid][aln_start][k1][:exon][info] = 1
				limits[:strand] = "+"
				if limits.key?(:start) == true
					if limits[:start] > aln_start
						limits[:start] = aln_start
					end
				else
					limits[:start] = aln_start
				end
				if limits.key?(:stop) == true
					if limits[:stop] < aln_end
						limits[:stop] = aln_end
					end
				else
					limits[:stop] = aln_end
				end
			end
		}

#		outfile.puts "#{subjectid}\tTRINITY\tmRNA\t#{limits[:start]}\t#{limits[:stop]}\t.\t#{limits[:strand]}\t.\tID=#{k1}\n"
		info = "#{subjectid}\tTRINITY\tmRNA\t#{limits[:start]}\t#{limits[:stop]}\t.\t#{limits[:strand]}\t.\tID=#{k1};Parent=#{k1}".to_s
		gff[contignum][subjectid][limits[:start]][k1][:mRNA][info] = 1
		info2 = "#{subjectid}\tTRINITY\tgene\t#{limits[:start]}\t#{limits[:stop]}\t.\t#{limits[:strand]}\t.\tID=#{k1}".to_s
		gff[contignum][subjectid][limits[:start]][k1][:gene][info2] = 1
	end

  end
}

# New file is opened to write the gff info
def open_new_file_to_write (number)
outfile = ""
	outfile = File.new("Blastn_to_gff3-#{number}.gff", "w")
	outfile.puts "##gff-version 3"
	outfile.puts "##mRNA row have 'Genelength' attribute presenting length of RNA-seq contig and exon rows have 'Target' attibute depicting start and stop mRNA match part"
outfile
end

number = 1
printfile = open_new_file_to_write(number)
puts printfile
counter = 500050
gff.sort.map do |num, v1|
 gff[num].each { |id, v2|
	if counter < 50
	  	number = number + 1
		printfile = open_new_file_to_write(number)
		counter = 500050
		puts printfile
	end
	gff[num][id].sort.map do |position, v3|
		gff[num][id][position].sort.map do |gene, v4|
		  reverse = Hash[gff[num][id][position][gene].sort.reverse]
		  reverse.each { |feature, v5|
			reverse[feature].each { |key, v6|
				printfile.puts "#{key}"
				counter = counter -1
			}
		  }
	  	end
	end
  }
end
