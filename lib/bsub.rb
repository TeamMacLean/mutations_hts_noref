#!/usr/bin/ruby
# encoding: utf-8
#

# make unique file name based on username and time
# taken from http://stackoverflow.com/a/14508272
def file_timestamp(file)
  dir  = File.dirname(file)
  base = File.basename(file, ".*")
  time = Time.now.to_i  # or format however you like
  ext  = File.extname(file)
  user = %x[echo $USER].chomp
  File.join(dir, "#{user}_#{base}_#{time}#{ext}")
end

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

script = "#!/bin/bash\n\
#SBATCH -n 1 # number of cores\n\
#SBATCH --mail-type=END,FAIL # notifications for job done & fail\n\
#SBATCH --mail-user=${USER}@nbi.ac.uk # send-to address\n"

temp_script = file_timestamp("/tmp/commands.sh")

%x[echo "#{script}" > #{temp_script}]
%x[echo "#{cmd}" >> #{temp_script}]

%x[sbatch #{partition} #{memory} #{temp_script}]

%x[rm #{temp_script}]
