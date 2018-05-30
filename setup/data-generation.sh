#!/bin/bash -
for n in `seq 1 11`
do
	week=1
	day=0
	j=0
	weight=$(( $RANDOM % 220 ))
	while [ $j -lt 38 ]
	do 
		day=$(( $day + 1 ))
		[ $day -eq 5 ] && { day=1; week=$(( $week + 1 )); }
		printf "$day,$week,,$weight\n"	
		j=$(( $j + 1 ))
	done
done

