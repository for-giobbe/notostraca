while getopts  ":i:f:c:a:b:h" o; do

    case "${o}" in

        i) i=${OPTARG}
            ;;
	f) f=${OPTARG}
            ;;
	c) c=${OPTARG}
            ;;
	a) a=${OPTARG}
            ;;
	b) b=${OPTARG}
            ;;
	h) echo "
			This script is used to find clade-eclusive ortholog clusters.

			List of non-optional arguments:

                        -i	input folder, containing interleaved or onliner .fa / .fas /.fasta files..
			-f	output file
			-a	list of clade spp
			-b	list of species to exclude
			-c	cutoff
                        -h	help page.
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

if [ -z "$i" ] || [ -z "$c" ] || [ -z "$f" ] || [ -z "$a" ] || [ -z "$b" ]
then
echo " WARNING! non-optional argument/s is missing "
exit
fi
  
################################################################################################################

first_grep_argument=$(cat $a | sed 's/ /\\\|/g' | sed "s/$/\\\/g")

second_grep_argument=$(cat $b | sed 's/ /" $j \&\& grep -qv "/g' | sed 's/$/" $j;/' | sed 's/^/grep -qv "/')

#echo $second_grep_argument
	
for j in $i/*.fa;

	do hits=$(grep -c "\<\($first_grep_argument)\>" $j); 

	if [[ hits -ge $c ]] && eval $second_grep_argument; 

	then echo $j >> $f; 

	fi; 

done
