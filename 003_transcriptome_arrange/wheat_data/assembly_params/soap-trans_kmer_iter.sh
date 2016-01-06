for k in 31 41 51 61 71 91 101;
    do source soapdenovo_trans-1.03; SOAPdenovo-Trans-127mer all -L 300 -p 16 -K $k -s sample.config -o assembly$k; done
