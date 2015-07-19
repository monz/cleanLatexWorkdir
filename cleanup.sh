#! /bin/bash

# clean up temporary files, created by compiling latex documents
# FIXME: cannot handle paths with whitespace, due to bash weirdness

# define default settings
RECURSIVE=false
filetypesFile="filetypes.txt"

# if insufficient arguments print usage
if [ -z "$1" ]; then
	echo "Usage: $0 -p=<path/to/clean> [-f/--filetypes] [-r/--recursive]"
	exit 1
fi	

# read command line arguments
for i in "$@"
do
case $i in
	-r|--recursive)
	RECURSIVE=true
	shift # past argument=value
	;;
	-p=*|--path=*)
	ROOTDIR="${i#*=}"
	shift # past argument=value
	;;
	-f=*|--filetypes=*)
	filetypesFile="${i#*=}"
	shift # past argument=value
	;;
	*)
	# unknown option
	;;
esac
done


# read standard filetypes of files that are going to be removed
i=0
while read -r line; do
	filetypes[$i]=$line
	i=$(($i+1))
done < $filetypesFile

# clean up given directory
function cleanUp {
	local rootDir=$1

	local texFiles=$(find "$rootDir" -name "*.tex")

	for filename in ${texFiles[@]}; do
		local texFile=${filename##*/}
		local myBasename=${texFile%.*}

		# delete file only if corresponding tex file exists
		for filetype in ${filetypes[@]}; do
			local fileToDelete=$rootDir/$myBasename*.${filetype}
			#rm $fileToDelete 2> /dev/null
			if [ -a $fileToDelete ]; then
				rm $fileToDelete
			fi
		done
	done
}

# return subdirectories of a root directory
function getSubDirs {
	local rootDir=$1
	local subDirs=$(ls -d $rootDir/*/ 2> /dev/null)
	echo $subDirs # return values to the caller
}

# clean directories recursive
function cleanUpDirectory {
	# clean up root directory
	local currentDir="$1";
	cleanUp "$currentDir"

	# clean up subdirectories
	local subdirs=$(getSubDirs "$currentDir")

	for subdir in ${subdirs[@]}; do
		cleanUpDirectory "${subdir}"
		cleanUp "${subdir}"
	done
}

# start clean up procedure
if [ -z "${ROOTDIR}" ]; then
	exit 1
fi

if $RECURSIVE; then
		cleanUpDirectory "$ROOTDIR"
else
		cleanUp "$ROOTDIR"
fi
exit 0
