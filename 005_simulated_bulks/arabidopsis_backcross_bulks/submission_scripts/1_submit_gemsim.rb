#!/usr/bin/ruby
# encoding: utf-8
#
require 'fileutils'

soft_source = 'source gemsim-1.6; GemReads.py'
error_model = '/tsl/software/testing/gemsim/1.6/src/GemSIM_v1.6/models/ill100v5_p.gzip'

input = File.expand_path(ARGV[0].chomp)
warn "main dir\t#{input}"
dirs = Dir.entries(input).select {|entry| File.directory? entry }
dirs.each do | dir |
  if dir =~ /^bulk\_/
    warn "bulk dir\t#{dir}"
    dir = File.expand_path(dir)
    FileUtils.chdir(dir)
    # write abundance files for GemSim
    [:wt, :mut].each do | group |
      bulkdir = 'pool_' + group.to_s
      filename = 'abundance_' + bulkdir + '.txt'
      for i in 1..10
        tag = group.to_s + '_' + i.to_s + '_sim_paired'
        warn "#{soft_source} -R #{bulkdir} -a #{filename} -p -l 100 -n 12500000 -u 350 -s 20 -m #{error_model} -q 33 -o #{tag}"
        %x[bsub.rb m-2d 6G "#{soft_source} -R #{bulkdir} -a #{filename} -p -l 100 -n 12500000 -u 350 -s 20 -m #{error_model} -q 33 -o #{tag}"]
      end
    end
    FileUtils.chdir(input)
  end
end


# bsub.rb m-2d 8G "source gemsim-1.6; GemReads.py -R pool_mut/ -a mut_abund.txt -p -l 100 -n 12500000 -u 350 -s 20 -m /tsl/software/testing/gemsim/1.6/src/GemSIM_v1.6/models/ill100v5_p.gzip -q 33 -o allen_mut_simulated_paried"
