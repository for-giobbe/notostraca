while getopts ":i:f:o:d:h" o; do
    case "${o}" in

   	i) input_folder=${OPTARG}
            ;;
	f) output_folder=${OPTARG}
            ;;
	o) occupancy=${OPTARG}
            ;;
   	d) data=${OPTARG}
            ;;
	h) echo "
	This script will filter gappy and misaligned positions from all the the alignments in the input folder, using Gblocks.

	List of non-optional arguments:

        	-i path to the input folder containing .aln files (aligned or unaligned oneliner fasta-formatted files) (write ./ to launch the script in the current folder).
        	-f path to the output folder.
		-o occupancy - can be (1) h for half (2) n for none (3) a for all.
		-d data type can be (1) p for proteins (2) d for DNA (3) c for codons.
		-h help page.

	Any Gblocks additional parameter can be changed manually in the script.
"
               exit
          ;;
       \?) echo "WARNING! -$OPTARG isn't a valid option"
           exit
          ;;
       :) echo "WARNING! missing -$OPTARG value"
          exit
          ;;
       esac
 done
if [ -z "$input_folder" ] || [ -z "$output_folder" ] || [ -z "$occupancy" ] || [ -z "$data" ]
then
 echo " WARNING! non-optional argument/s is missing "
exit
fi
 

########################################################################################################################################
	
	mkdir $output_folder

	cd $input_folder

	for i in *.aln;
	
		do ../../../scripts/Gblocks_0.91b/Gblocks $i -t="$data" -b5="$occupancy" &>/dev/null;
	
	done
	
	rm *htm

	for i in *-gb; 
	
		do name=$(echo $i | sed 's/\.aln-gb//'); 
		cat $i | tr -d " " | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' > $name".gb.aln"; 
		rm $i;
	done

	mv *.gb.aln ../$output_folder
