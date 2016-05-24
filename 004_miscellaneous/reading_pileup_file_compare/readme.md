### Comparing pileup file reading using simple scripts

It felt quite slow reading pileup files using a ruby script that imports multiple gems and 
performing IO actions on a pileup file

Details about pileup format can be found at following link
[http://samtools.sourceforge.net/pileup.shtml](http://samtools.sourceforge.net/pileup.shtml)

So tried to test time differences using three different scripts

[read\_mpileup\_biosamtools.rb](./read_mpileup_biosamtools.rb) script is implementation of biosamtools and bio-gngm gems to read a simple pileup file

[simple\_ruby\_processor\_char\_count.rb](./simple_ruby_processor_char_count.rb) script is same implementation as above but without any gems and counting characters of read bases information

[simple\_ruby\_processor\_count.rb](./simple_ruby_processor_count.rb) script is same implementation as above but without any gems and uses native string count method for read bases information


#### Ruby and gem version information

```
⇒  ruby -v
ruby 2.2.1p85 (2015-02-26 revision 49769) [x86_64-darwin14]

⇒  gem list 'bio'

*** LOCAL GEMS ***

bio (1.5.0)
bio-gem (1.3.6)
bio-gngm (0.2.1)
bio-samtools (2.3.3)
bio-svgenes (0.4.1)
```



#### Testing with a small file

Using a file with 10 million lines and the archive of the file is available to [download](http://www.mediafire.com/download/5gefvn3qa26shia/10m_lines.pileup.gz)


1. using ruby script with bio-samtools and bio-gngm gems

```
for i in {1..5}; do sudo purge && time ruby read_mpileup_biosamtools.rb 10m_lines.pileup ; done

real	1m49.877s
user	1m46.812s
sys	0m0.964s

real	1m47.551s
user	1m45.370s
sys	0m0.942s

real	1m48.426s
user	1m46.465s
sys	0m0.806s

real	1m47.045s
user	1m45.011s
sys	0m0.839s

real	1m49.186s
user	1m46.944s
sys	0m0.978s
```

on average it took 1m and 48 seconds to process the pileup file


2. using ruby script that uses native string count and in script methods

```
for i in {1..5}; do sudo purge && time ruby simple_ruby_processor_count.rb 10m_lines.pileup; done

real	0m36.880s
user	0m35.597s
sys	0m0.724s

real	0m37.569s
user	0m36.138s
sys	0m0.827s

real	0m35.655s
user	0m34.625s
sys	0m0.616s

real	0m37.385s
user	0m36.262s
sys	0m0.698s

real	0m36.222s
user	0m35.193s
sys	0m0.621s
```

on average it took 36 seconds to process the pileup file


3. using ruby script that use in script methods and char counting

```
for i in {1..5}; do sudo purge && time ruby simple_ruby_processor_char_count.rb 10m_lines.pileup; done

real	4m26.811s
user	4m11.027s
sys	0m3.439s

real	3m49.194s
user	3m45.997s
sys	0m1.833s

real	3m47.034s
user	3m43.527s
sys	0m2.039s

real	3m41.440s
user	3m39.284s
sys	0m1.446s

real	3m42.958s
user	3m40.288s
sys	0m1.678s

```
on average it took about 3 min 53 seconds to process the pileup file



#### bottom line

it seems using in script methods and string count is 3 times faster than using ruby gem importing

and more than 6 times faster than in script methods and char count form the string

