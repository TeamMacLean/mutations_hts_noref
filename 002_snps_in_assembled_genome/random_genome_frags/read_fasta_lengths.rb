#encoding: utf-8
require 'bio'

Bio::FastaFormat.open(ARGV[0]).each do |i|
    puts "#{i.entry_id}\t#{i.length}"
end
