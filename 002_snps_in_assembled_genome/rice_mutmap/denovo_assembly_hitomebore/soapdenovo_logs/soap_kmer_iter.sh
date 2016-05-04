for k in 25 31 35 41 45 51 55 61;
    do
	source soapdenovo2-2.40; SOAPdenovo-127mer pregraph -p 32 -K $k -d 1 -s sample.config -o assembly_$k;
	source soapdenovo2-2.40; SOAPdenovo-127mer contig -g assembly_$k;
    done
