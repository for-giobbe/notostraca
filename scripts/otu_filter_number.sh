while getopts ":c:i:f:h" o; do
    case "${o}" in

        c) n=${OPTARG}
            ;;
	i) i=${OPTARG}
            ;;
	f) f=${OPTARG}
            ;;
	h) echo "
                        This script will filter out the alignments in the input folder which are under an OTU number cutoff.
			
			List of non-optional arguments:

			-i path to the input folder containing .aln files (aligned or unaligned oneliner fasta-formatted files) (write ./ to launch the script in the current folder).
			-f path to the output folder.
			-c OTU cutoff value.
			-h help page.
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
if [ -z "$n" ] || [ -z "$i" ] || [ -z "$f" ]
then
 echo " WARNING! non-optional argument/s is missing "
exit
fi

#####################################################################################################################

mkdir ./$f

for j in ./$i/*.aln*;

do export a=$(grep ">" $j | wc -l);

if [ $a -ge "$n" ];

then cp $j $f;

fi;

done
