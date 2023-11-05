#!/bin/bash

echo "--------------------------"
echo "User Name: KangYuJin"
echo "Student Number: 12223690"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.data'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4.Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of mpviex rated by users with 'age' between 20 and 29 and 'occupation' ad 'programmer'"
echo "9. Exit"
echo "--------------------------"

stop="N"
until [ $stop = "Y" ]
do
	read -p "Please your choice [ 1-9 ] " n
	case $n in
	1 )
		echo ""
		read -p "Please enter 'movie id' (1~1682):" mid
		echo ""
		cat u.item | awk -F\| -v input_mid="$mid" '$1==input_mid {print $0}'
		echo ""
		;;
	2 ) 
		echo ""
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n) : " check
		echo ""
		if [ $check = "y" ]; then
			cat u.item | awk -F\| '$7==1 {print $1, $2}' | head -n 10
			echo ""
		fi
		;;
	3 )
		echo ""
		read -p "Please enter the 'movie id' (1~1682): " mid
		echo ""
		uNum=$(cat u.data | awk -v input_mid="$mid" '$2==input_mid {count++; printf("%d\n", count)}' | tail -n 1)
		rating=$(cat u.data | awk -v input_mid="$mid" '$2==input_mid {sum+=$3; printf("%d\n", sum)}' | tail -n 1)
		echo $uNum $rating | awk -v input_mid="$mid" '{ res=$2/$1; printf("average rating of %d: %.5f\n", input_mid, res) }' 
		echo ""
		;;
	4 )
		echo ""
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " check
		echo ""
		if [ $check = "y" ]; then
		cat u.item | sed -E 's|http://[^|]*||' | head -n 10	
		echo ""
		fi
		;;
	5 )	
		echo ""
		read -p "Do you want to get the data about users from 'u.user'?(y/n): " check
		echo ""
		if [ $check = "y" ]; then
		cat u.user | awk -F\| '$3=="F" {gender="female"} $3=="M" {gender="male"} {printf("user %d is %d years old %s %s\n", $1, $2, gender, $4)}' | head -n 10
		echo""
		fi 
		;;
	6 ) 	
		echo ""
		read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n): " check
		echo "" 
		if [ $check = "y" ]; then
		stoNum=$(cat u.item | sed 's/\([0-9]\{2\}\)-\([A-Za-z]\{3\}\)-\([0-9]\{4\}\)/ \3-\2-\1/')
		stoNum=$(echo "$stoNum" | sed -E 's/-Jan-/01/; s/-Feb-/02/' )
		stoNum=$(echo "$stoNum" | sed -E 's/-Mar-/03/; s/-Apr-/04/' )
		stoNum=$(echo "$stoNum" | sed -E 's/-May-/05/; s/-Jun-/06/' )
		stoNum=$(echo "$stoNum" | sed -E 's/-Jul-/07/; s/-Aug-/08/' )
		stoNum=$(echo "$stoNum" | sed -E 's/-Sep-/09/; s/-Oct-/10/' )
		stoNum=$(echo "$stoNum" | sed -E 's/-Nov-/11/; s/-Dec-/12/' )
		stoNum=$(echo "$stoNum" | sed -r 's/\| ([0-9]{8})/\|\1/g')
		echo "$stoNum" | tail -n 10
		echo ""	
		fi
		;;
	7 )
		echo ""
		read -p "Please enter the 'user id' (1~943): " uid
		echo ""
		midList=$(cat u.data | awk -v input_uid="$uid" '$1==input_uid {printf("%d\n", $2)}')
		sorted=$(echo "$midList" | tr ' ' '\n' | sort -n )
		midList=$(echo "$sorted" | tr ' ' '\n' | awk '{ printf("%d\n", $1) }' | tr '\n' '|')
		sorted="${midList%?}"
		echo "$sorted"
		echo ""
		count=1
		while [ $count -le 10 ]
		do
			movies=$(echo "$midList" | tr '|' '\n' | awk -v cnt="$count" 'NR==cnt {print $1}')
			cat u.item | awk -F\| -v mvs="$movies" '$1==mvs {printf("%d|%s\n", $1, $2)}'
			let count=count+1
		done
		echo ""
		;;
	8 ) 	
		echo ""
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " check
		echo ""
		if [ $check = "y" ]; then
		users=$(cat u.user | awk -F\| '$2>=20 && $2<=29 {print $0}')
		users=$(echo "$users" | awk -F\| '$4=="programmer" {print $0}')
		lines=$(echo "$users" | wc -l)
		count=1
		while [ $count -le $lines ]
		do
			user=$(echo "$users" | awk -F\| -v cnt="$count" 'NR==cnt {print $1}')
			datas=$(echo -e "${datas}\n$(cat u.data | awk -v user_id="$user" '$1==user_id {print $0}')")
			let count=count+1
		done
		echo "$datas" | awk '{sum[$2]+=$3; count[$2]++} END {for (i in sum) printf("%d %.6g\n", i, sum[i]/count[i])}' | sort -n | tail -n +2 
		echo ""
		fi
		;;
	9 ) 
		echo "Bye!"
		stop="Y"	;;
	* ) echo "Invalid choice!" ;;
	esac
done



