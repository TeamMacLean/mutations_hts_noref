#
# This script calculates the depth of coverage and breadth of coverage for a given bam.
# Outputs a dictionary containing the contig/chromosome names and the depth and breadth of coverage for each
# and for the entire genome.
#
# If you optionally specify the name of the mitochondrial chromosome (e.g. mtDNA, chrM, chrMT)
# The script will also generate breadth and depth of coverage for the nuclear genome AND the ratio
# of mtDNA:nuclearDNA; which can act as a proxy in some cases for mitochondrial count within an individual.
#
# Author: Daniel E. Cook
# Website: Danielecook.com
#
# Fork by Julie Orjuela and Enrique Ortega
#
# depth_of_coverage.py downloaded from https://gist.github.com/3nrique0/cca23f6dab1cd2f8f9ee
# modified by Shyam Rallapalli
#

import os
import re
import sys
from subprocess import Popen, PIPE

def get_contigs(bam):
  header, err = Popen(['samtools','view','-H',bam], stdout=PIPE, stderr=PIPE).communicate()
  if err != '':
    print('The command \'samtools view -H {0}\' failed to execute with the following error:\n'.format(bam))
    raise Exception(err)
  # Extract contigs from header and convert contigs to integers
  contigs = {}
  for x in re.findall('@SQ\WSN:(?P<chrom>[A-Za-z0-9_]*)\WLN:(?P<length>[0-9]+)', header):
    contigs[x[0]] = int(x[1])
  return contigs

def coverage(bam, filename):
  # Check to see if file exists
  if os.path.isfile(bam) == False:
    raise Exception('Bam file does not exist')
  contigs = get_contigs(bam)

  coverage_dict = {}
  outfile = open(filename, 'w')
  print >>outfile, '\t'.join(('id', 'Length', 'Depth of Coverage', 'Breadth of Coverage', 'Bases Mapped','Sum of Depths'))

  for c in contigs.keys():
    command = 'samtools depth -r %s %s | awk \'{sum+=$3;cnt++}END{print cnt \"\t\" sum}\'' % (c, bam)
    outcome = Popen(command, stdout=PIPE, shell = True).communicate()[0].strip()

    coverage_dict[c] = {}
    # set zero depth for contigs with out alignments
    if outcome == '':
      coverage_dict[c]['Bases Mapped'] = 0
      coverage_dict[c]['Sum of Depths'] = 0
    else:
      coverage_dict[c]['Bases Mapped'], coverage_dict[c]['Sum of Depths'] = map(int, outcome.split('\t'))

    coverage_dict[c]['Breadth of Coverage'] = coverage_dict[c]['Bases Mapped'] / float(contigs[c])
    coverage_dict[c]['Depth of Coverage'] = coverage_dict[c]['Sum of Depths'] / float(contigs[c])
    coverage_dict[c]['Length'] = int(contigs[c])

    v = coverage_dict[c]
    print >>outfile, '\t'.join(map(str,(c, v.get('Length'), v.get('Depth of Coverage'), v.get('Breadth of Coverage'), v.get('Bases Mapped'),v.get('Sum of Depths'))))

  # Calculate Genome Wide Breadth of Coverage and Depth of Coverage
  genome_length = float(sum(contigs.values()))
  coverage_dict['genome'] = {}
  coverage_dict['genome']['Length'] = int(genome_length)
  coverage_dict['genome']['Bases Mapped'] = sum([x['Bases Mapped'] for k, x in coverage_dict.iteritems() if k != 'genome'])
  coverage_dict['genome']['Sum of Depths'] = sum([x['Sum of Depths'] for k, x in coverage_dict.iteritems() if k != 'genome'])
  coverage_dict['genome']['Breadth of Coverage'] = sum([x['Bases Mapped'] for k, x in coverage_dict.iteritems() if k != 'genome']) / float(genome_length)
  coverage_dict['genome']['Depth of Coverage'] = sum([x['Sum of Depths'] for k, x in coverage_dict.iteritems() if k != 'genome']) / float(genome_length)
  print str(coverage_dict['genome']['Depth of Coverage'])

  v = coverage_dict['genome']
  print >>outfile, '\t'.join(map(str,('genome', v.get('Length'), v.get('Depth of Coverage'), v.get('Breadth of Coverage'), v.get('Bases Mapped'),v.get('Sum of Depths'))))
  outfile.close


def main():
  if len(sys.argv) == 3:
    coverage(sys.argv[1], sys.argv[2])
  else:
    sys.exit('Provide a bam file and output file name as input arguments\n')

  pass

main()
