#!/usr/bin/ruby
# encoding: utf-8
#
require 'bio'

def return_aln_parameters_query (hash)
	data = Hash.new {|h,k| h[k] = {} }
	hash.each_key { |a|
		hash[a].each_key { |c|
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
	hash2.each_key { |key|
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
	#if blastdata[2].to_f > 98.0 and blastdata[11].to_f > 500.0
	#if blastdata[2].to_f > 96.0 and blastdata[10].to_f == 0.0 and blastdata[3].to_f > 100.0
	if blastdata[2].to_f > 96.0 and blastdata[10].to_f == 0.0
		if blastdata[9].to_i > blastdata[8].to_i
			q_id = [blastdata[1],"+"].join("_")
			blast[blastdata[0]][q_id][string] = 1
		else
			q_id = [blastdata[1],"-"].join("_")
			blast[blastdata[0]][q_id][string] = 1
		end
	end
  end
end

gff = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) } ## vivified hash
blast.each_key { |k1|

  data2 = return_aln_parameters_query(blast[k1])
  subjectid = return_best_contig_aln(data2)

  if subjectid =~ /\w/
	genelen_cov = (100* data2[subjectid]["alnlength"].to_i)/genes[k1].to_i
	mismatch_cov = (100* data2[subjectid]["mismatch"].to_i)/genes[k1].to_i
	#if genelen_cov >= 40 and mismatch_cov <=10
		limits = Hash.new {|h,k| h[k] = {} }
		s_id = subjectid.sub(/\_[+-]$/, '')
		contignum = ""
		if s_id =~ /\_(\d+)$/
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
#				info = "#{subjectid}\tblastn\texon\t#{aln_end}\t#{aln_start}\t.\t-\t.\tParent=#{k1};Target=#{k1} #{array2[7].to_i} #{array2[6].to_i};Genelength=#{genes[k1]}".to_s
#				gff[contignum][subjectid][aln_end][k1][:exon][info] = 1
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
#				info = "#{subjectid}\tblastn\texon\t#{aln_start}\t#{aln_end}\t.\t+\t.\tParent=#{k1};Target=#{k1} #{array2[6].to_i} #{array2[7].to_i};Genelength=#{genes[k1]}".to_s
#				gff[contignum][subjectid][aln_start][k1][:exon][info] = 1
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
#		info = "#{subjectid}\tTRINITY\tmRNA\t#{limits[:start]}\t#{limits[:stop]}\t.\t#{limits[:strand]}\t.\tID=#{k1};Parent=#{k1}".to_s
#		gff[contignum][subjectid][limits[:start]][k1][:mRNA][info] = 1
		info2 = "#{s_id}\tblastn\tgene\t#{limits[:start]}\t#{limits[:stop]}\t.\t#{limits[:strand]}\t.\tID=#{k1}\t#{genes[k1]}".to_s
		gff[contignum][s_id][limits[:start]][k1][:gene][info2] = 1
	#end

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
 gff[num].each_key { |id|
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
