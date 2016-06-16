if [ $# -lt 1 ];then
	exit 1
fi

i=1
len=0
input=''
LINE_NUM=100
hcmds=$(history |grep -v fcmd | tail -$LINE_NUM | grep "$*")
hnum=$(echo "$hcmds" |wc -l)
if [ $hnum -lt 1 ];then
	exit 1
fi

while [ -n $input ]
do
	cmd=$(echo "$hcmds" | tail -$i | head -1)
	cmd=$(echo $cmd | awk '{for(i=2;i<=NF;i++){print $i}}')
	if [ -z "$cmd" ];then
		break
	fi

	echo -ne "\r"
	for((j=0;j<$len;j++))
	do
		echo -n " "
	done
	echo -ne "\r"$cmd

	read -n 1 -s input
	if [ "$input" == "w" ];then
		i=$((i+1))
		if [ $i -gt $hnum ];then
			i=1
		fi
	elif [ "$input" == "s" ];then
		i=$((i-1))
		if [ $i -lt 1 ];then
			i=$hnum
		fi
	elif [ "$input" == "q" ];then
		exit 1
	elif [ -z "$input" ];then
		break
	fi
	len=${#cmd}
done

echo ''
eval $cmd
