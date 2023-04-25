#!/usr/bin/bash

function backup {

if [ -z $1 ]; then 
	user=$(whoami)
else 
	if [ ! -d "/home/$1" ]; then 
		echo "requested $1 user home directory doesn't exist."
		exit 1
	fi 
	user=$1
fi

input=/home/$user
output=/tmp/${user}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz

function total_files {
	find $1 -type f | wc -l
}

function total_directories {
	find $1 -type d | wc -l
}

function total_archived_directories {
	tar -tzf $1 | grep /$ | wc -l
}

function total_archived_files {
	tar -tzf $1 | grep -v /$ | wc -l
}

tar -czf $output $input 2> /dev/null

src_files=$( total_files $input )
src_directories=$( total_directories $input )

arch_files=$( total_archived_files $output)
arch_directories=$( total_archived_directories $output)

echo "================$user================="
echo "files to be included: $src_files"
echo "directories to be included: $src_directories"
echo "files archived: $arch_files"
echo "directories archived: $arch_directories"

if [ $src_files -eq $arch_files ]; then
	echo "backup of $input completed!"
	echo "detail about the output backup file:"
	ls -l $output
else 
	echo "backup of $input fail"
fi


}

for directory in $*; do
	backup $directory
done



