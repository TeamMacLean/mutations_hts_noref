for k in 25 31 41 51 61;
    do
	source soapdenovo_trans-1.03; SOAPdenovo-Trans-127mer pregraph -p 32 -K $k -d 1 -s sample.config -o assembly_$k;
	source soapdenovo_trans-1.03; SOAPdenovo-Trans-127mer contig -g assembly_$k;
    done
