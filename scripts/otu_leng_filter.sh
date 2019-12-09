while getopts ":i:f:c:h" o; do
    case "${o}" in

        i) input_folder=${OPTARG}
            ;;
	f) output_folder=${OPTARG}
            ;;
	c) length_cutoff=${OPTARG}
            ;;
	h) echo "
                        This script will filter out the sequences which are under a length ctuoff from all the alignments in the input folder.

			List of non-optional arguments:

                        -i path to the input folder containing .aln files (aligned or unaligned oneliner fasta-formatted files) (write ./ to launch the script in the current folder).
                        -f path to the output folder.
			-c length cutoff value.
			-h help page.
			
			In the last step the script will eliminate all the empty alignment (in which none of the sequences survived the length filter).

			The output folder will contain also a length_stats summary file.
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
if [ -z "$input_folder" ] || [ -z "$output_folder" ] || [ -z "$length_cutoff" ]
then
 echo " WARNING! non-optional argument/s is missing "
exit
fi
 

########################################################################################################################################
	
	mkdir $output_folder

	cp $input_folder/*.aln $output_folder/
	
	for i in $output_folder/*.aln;

		do for j in $(grep ">" $i | sed 's/>//g');

			do a=$(grep -A 1 $j $i | tail -1 | sed 's/-//g' | wc -c);

			l1=$(grep $j $i);
			l2=$(grep -A 1 $j $i | tail -1);

			echo $i $j $a $length_cutoff >> $output_folder/length_stats;

			if [ $a -lt $length_cutoff ];
 
			then sed -i '/'$l1'/d' $i; sed -i '/'$l2'/d' $i;

			fi; 

		done;

	done;

# removes empty files

for i in $(ls -l $output_folder | awk -F " " '{print $5"_"$9}' | grep -E '^1_|^0_' | grep -E '.aln$'); do a=$(echo $i | awk -F "_" '{print $2}'); rm $output_folder/$a ; done;

rm -f sed*
