#!/usr/bin/ruby
# encoding: utf-8
#

if ARGV.empty?
  puts "  Please specify a partition queue - tiny / short / med / long,\n\
  and a command to run in quotations. For example as following\n\
  short \"source varscan-2.3.9; varscan mpileup2indel samtools.pileup --output-vcf 1 > varscan_vars.vcf\""
  exit
end

queue = ARGV[0].chomp
cmd = ARGV[1]
# partition = ''
script = ''
# warn "#{queue}\t#{cmd}\n"
unless ARGV[2].nil?
  warn "please include command in quotations"
  exit
end

# taken from http://stackoverflow.com/a/14508272
def file_timestamp(file)
  dir  = File.dirname(file)
  base = File.basename(file, ".*")
  time = Time.now.to_i  # or format however you like
  ext  = File.extname(file)
  File.join(dir, "#{base}_#{time}#{ext}")
end

# tiny has 1GB mem requirement
if queue == 'tiny'
  # partition = '-p tsl-short'
  script = '/usr/users/sl/rallapag/lib/tiny_slurm.sh'
# short has 2GB mem requirement
elsif queue == 'short'
  # partition = '-p tsl-short'
  script = '/usr/users/sl/rallapag/lib/short_slurm.sh'
# med has 12GB mem requirement
elsif queue == 'med'
  # partition = '-p tsl-medium'
  script = '/usr/users/sl/rallapag/lib/med_slurm.sh'
# long has 65GB mem requirement
elsif queue == 'long'
  # partition = '-p tsl-long'
  script = '/usr/users/sl/rallapag/lib/long_slurm.sh'
else
  warn "incorrect queue. use either tiny or short or med or long queue"
  exit
end

temp_script = file_timestamp("/usr/users/sl/rallapag/lib/temp/commands.sh")

%x[cp #{script} #{temp_script}]
%x[echo "#{cmd}" >> #{temp_script}]

# %x[sbatch #{partition} #{temp_script}]
%x[sbatch #{temp_script}]
