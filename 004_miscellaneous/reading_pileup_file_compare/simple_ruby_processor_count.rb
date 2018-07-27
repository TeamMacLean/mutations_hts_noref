# encoding: utf-8

def is_snp(p, options)
  return false if p[4] == '*'
  return false if options[:ignore_reference_n] and p[2] == 'N' or p[2] == 'n'
  return true if p[3].to_i >= options[:min_depth] and non_ref_count(p[4]) >= options[:min_non_ref_count]
  false
end

def non_ref_count(str)
  str.count('ATGCatgc')
end


vars_hash = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
opts = { :ignore_reference_n => true, :min_depth => 6, :min_non_ref_count => 3}

File.foreach(ARGV[0]) do |line|
  split_line = line.split("\t")
  if is_snp(split_line, opts)
    vars_hash[split_line[0]][split_line[1].to_i] = split_line
  end
end