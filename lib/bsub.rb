#!/usr/bin/ruby
# encoding: utf-8
#

# set partition or queue to submit a job
def set_partition(arg)
  partition = ''
  if arg == 'short'
    partition = '-p tsl-short'
  elsif arg == 'med'
    partition = '-p tsl-medium'
  elsif arg == 'long'
    partition = '-p tsl-long'
  else
    warn "incorrect queue. use either short or med or long queue"
    exit
  end
  partition
end

# set memory required for the job
def set_memory(arg)
  ram = 0
  if /^(?<size>\d+)(?<format>[mgtMGT])$/ =~ arg
    if format == 'M' || format == 'm'
      ram = size.to_i
    elsif format == 'G' || format == 'g'
      ram = size.to_i * 1024
    elsif format == 'T' || format == 't'
      ram = size.to_i * 1024 * 1024
    end
  else
    warn "and amount of RAM required for the job in M / G / T example 2048M or 2G or 1T etc.."
    exit
  end
  memory = "--mem=#{ram}"
  memory
end

if ARGV.empty?
  puts "Please specify a partition queue - short / med / long\n\
  and amount of RAM required for the job in M / G / T example 2G or 2048M or 1T etc..\n\
  and a command to run in quotations. For example as following\n\
  short 2G \"source varscan-2.3.9; varscan mpileup2indel samtools.pileup --output-vcf 1 > varscan_vars.vcf\""
  exit
end

partition = set_partition(ARGV[0].chomp)
memory = set_memory(ARGV[1].chomp)
cmd = ARGV[2]
unless ARGV[3].nil?
  warn "please include command in quotations"
  exit
end

%x[sbatch #{partition} #{memory} -n 1 --mail-type=END,FAIL --mail-user=${USER}@nbi.ac.uk --wrap=#{cmd}]
