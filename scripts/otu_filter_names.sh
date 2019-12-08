while getopts  ":l:i:f:d:h" o; do

    case "${o}" in

        l) l=${OPTARG}
            ;;
	i) i=${OPTARG}
            ;;
	f) f=${OPTARG}
            ;;
	d) d=${OPTARG}
            ;;
	h) echo "
                        This script has to be launched in a folder with onliner .fas files.

			List of non-optional arguments

                        -l	file containing a list of OTU (one line, separated by whitespaces).
			-i	input folder
			-f	outpout folder, just specify a name to have it inside the current folder.
			-d	if TRUE delets undesired OTUs from each MSA
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
if [ -z "$l" ] || [ -z "$i" ] || [ -z "$f" ] || [ -z "$d" ]
then
 echo " WARNING! non-optional argument/s is missing "
exit
fi

##################################################################################################################### input

mkdir ./$f

##################################################################################################################### create output directory

length=$(wc -w $l | awk '{print $1}'); for n in $(eval echo {1..$length}); do export a"$n"=$(awk '{print $'$n'}' $l); done

##################################################################################################################### create single OTU variables

string=$(for k in $(eval echo {1..$length}); do echo -n "yo -e" "\"""yo$"""a""$k"""\""  | sed 's/yo//g'; done)

	for j in $i/*.aln; 
		
	do export a=$(eval grep $string $j | wc -l);

		if [ $a -ge $length ];
		
			then cp $j ./$f;
		
		fi;
	

	
	done

##################################################################################################################### optional

	if [ "$d" == "TRUE" ];

               then for r in ./$f/*.aln;

                       do for s in $(grep ">" $r | sed 's/>//g');

				do export l1=$(grep $s $r); export l2=$(grep -A 1 $s $r | tail -1);

# echo $s $l $l1 $l2 $r
				
if ! grep $s $l; then sed -i '/'$l1'/d' $r; sed -i '/'$l2'/d' $r; fi;

				done;

		done;

	fi;
