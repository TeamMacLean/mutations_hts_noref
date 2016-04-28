#!/usr/bin/ruby
# encoding: utf-8
#

# set partition or queue to submit a job
def set_partition(arg)
  if arg =~ /-/
    args = arg.split('-')
    arg1 = args[0]
    arg2 = args[1]
  else
    arg1 = arg
    arg2 = ''
  end

  partition = ''
  if arg1 == 'short' or arg1 == 's'
    partition = '-p tsl-short'
  elsif arg1 == 'med' or arg1 == 'm'
    partition = '-p tsl-medium'
  elsif arg1 == 'long' or arg1 == 'l'
    partition = '-p tsl-long'
  else
    warn "incorrect queue. use either short or med or long queue"
    exit
  end

  time = ''
  unless arg2 == ''
    number = /^(\d+)\w/.match(arg2)[1].to_i
    format = /^\d+(\w)/.match(arg2)[1].to_s
    if format == 'm' or format == 'mins'
      time = "-t 00:#{number}:00"
    elsif format == 'h' or format == 'hrs'
      time = "-t #{number}:00:00"
    elsif format == 'd' or format == 'days'
      time = "-t #{number}-00:00:00"
    else
      time = ''
    end
  end
  [partition, time]
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
  default timelimit for these queues: short - 6hrs, med - 7days and long 365days\n\
  including a number with hyphen after quename with h or hrs or d or days will add time limit to the queue\n\
  and amount of RAM required for the job in m or M or g or G example 2G or 2048M etc..\n\
  and a command to run in quotations. For example as following\n\
  short 2G \"source varscan-2.3.9; varscan mpileup2indel samtools.pileup --output-vcf 1 > varscan_vars.vcf\""
  exit
end

partition, time = set_partition(ARGV[0].chomp)
memory = set_memory(ARGV[1].chomp)
cmd = ARGV[2]
unless ARGV[3].nil?
  warn "please include command in quotations"
  exit
end

log = %x[sbatch #{partition} #{time} #{memory} -n 1 --mail-type=END,FAIL --mail-user=${USER}@nbi.ac.uk  --acctg-freq=task=05 --wrap="#{cmd}"]
puts "#{log}"
