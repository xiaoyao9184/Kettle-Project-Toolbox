#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2021-04-09
# FILE COPY_REPOSITORY_ALL
# DESC copy one or more repository meta(s) and file(s)
# PARAM none
# --------------------
# CHANGE 2021-04-09
# init
# --------------------


# var
tip="Kettle-Project-Toolbox: Copy Repository"
ver="1.0"

# interactive
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0

# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parent_path="$(dirname "$current_path")"

# tip info
echorName="Need input name for copy (default: dev.*)"
esetrName="Please input name for copy:"

echorNameRegex="Need input match regex of repository name (default: dev.*)"
esetrNameRegex="Please input match regex of repository name:"

echorNameRemove="Need input string for seach (default: dev)"
esetrNameRemove="Pleaseinput string for seach:"

echorNameReplace="Need input string for reaplce (default: )"
esetrNameReplace="Please input string for reaplce"

echorNameNew="Need input name of new repository"
esetrNameNew="Please input name of new repository:"

echorPath="Need input path of new repository"
esetrPath="Please input path of new repository:"

echorMetaSource="Need input path of read repository meta"
esetrMetaSource="Please input path of read repository meta"

echorMetaTarget="Need input path of write repository meta"
esetrMetaTarget="Please input path of write repository meta:"

# defult param
pdi_path=$parent_path/data-integration
rNameRegex=
rNameRemove=
rNameReplace=
rNameNew=
rPath=
rPathType=
rMetaSource=
rMetaTarget=
isCopyFile=

# title
echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Can be closed after the run ends"
echo "..."


# check
while true; do
    read -p "copy one(Y), copy more(N)?" yn
    case $yn in
        [Yy]* ) tempOm="one"; break;;
        [Nn]* ) tempOm="more"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
if [ "$tempOm" != "one" ] ;then
    if [ "$rNameRegex"=="" ]
	then
		echo $echorName
		read -p "$esetrName" rNameRegex
	fi

	while true; do
		read -p "config name for copy, use new name(Y), or relpace old name(N)?" yn
		case $yn in
			[Yy]* ) tempName="new"; break;;
			[Nn]* ) tempName="replace"; break;;
			* ) echo "Please answer yes or no.";;
		esac
	done

	if [ "$tempName"=="new" ]
	then
		echo $echorNameNew
		read -p "$esetrNameNew" rNameNew
	fi

	if [ "$tempName"=="replace" ]
	then
		if [ "$rNameRemove"=="" ]
		then
			echo $echorNameRemove
			read -p "$esetrNameRemove" rNameRemove
		fi

		if [ "$rNameReplace"=="" ]
		then
			echo $echorNameRemove
			read -p "$esetrNameReplace" rNameReplace
		fi
	fi
else
	if [ "$rNameRegex"=="" ]
	then
		echo $echorNameRegex
		read -p "$esetrNameRegex" rNameRegex
	fi
	
	if [ "$rNameRemove"=="" ]
	then
		echo $echorNameRemove
		read -p "$esetrNameRemove" rNameRemove
	fi

	if [ "$rNameReplace"=="" ]
	then
		echo $echorNameRemove
		read -p "$esetrNameReplace" rNameReplace
	fi
fi

while true; do
    read -p "config repository path? (default is use name for path name)" yn
    case $yn in
        [Yy]* ) tempPath="config"; break;;
        [Nn]* ) tempPath="none"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
if [ "$tempPath"=="config" ]
then
	if [ "$rPath"=="" ]
	then
		echo "NOTE: if use \ suffix, will be judged as a fuzzy path and used as the parent path of the new repository)"
		echo $echorPath
		read -p "$esetrPath" rPath
	fi

	if [ -d "$rPath" ] ; then
		while true; do
			read -p "copy repository path name, same as old path name(Y), or as repository name(N)?" yn
			case $yn in
				[Yy]* ) rPathType="1"; break;;
				[Nn]* ) rPathType="0"; break;;
				* ) echo "Please answer yes or no.";;
			esac
		done
	else
fi

while true; do
    read -p "need copy repository path?" yn
    case $yn in
        [Yy]* ) isCopyFile="1"; break;;
        [Nn]* ) isCopyFile="0"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "need change kettle home path?" yn
    case $yn in
        [Yy]* ) tempHome="config"; break;;
        [Nn]* ) tempHome="none"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
if [ "$tempHome"=="config" ]
then
	if [ "$rMetaSource"=="" ]
	then
		echo $echorMetaSource
		read -p "$esetrMetaSource" rMetaSource
	fi
	if [ "$rMetaTarget"=="" ]
	then
		echo $echorMetaTarget
		read -p "$esetrMetaTarget" rMetaTarget
	fi
fi

# begin
tempParam="-param:isCopyFile=$isCopyFile -param:rNameRegex=$rNameRegex"

if [ "$tempUser" == "default" ]
then
	echo "Kettle will use the repository meta in the user.kettle path as the input and output location"
else
	echo "Kettle will read repository meta from: $rMetaSource"
	echo "Kettle will copy repository meta to: $rMetaTarget"
	tempParam="$tempParam -param:rMetaSource=$rMetaSource -param:rMetaTarget=$rMetaTarget"
fi

if [ "$tempOm" == "one" ]
	echo "Kettle will copy one repository: $rNameRegex"
then
	echo "Kettle will copy multiple repositories: $rNameRegex"
fi

if [ "$isCopyFile" == "1" ]
	echo "Kettle will copy the repository path"
then
	echo "Kettle will not copy the repository path"
fi

if [ "$tempName" == "new" ]
	echo "Kettle will name the repository as: $rNameNew"
	tempParam="$tempParam -param:rNameNew=$rNameNew"
then
	echo "Kettle will name the repository as: $rNameRemove -> $rNameReplace"
	tempParam="$tempParam -param:rNameRemove=$rNameRemove -param:rNameReplace=$rNameReplace"
fi

if [ "$rPath" == "" ]
	echo "Kettle will modify the meta path to be in the same path as the old meta, and have configured the name to name the path" 
then
	echo "Kettle will modify the meta(parent) path to: $rPath"
	if [ "$rPathType" == "1" ]
		echo "Kettle will use the old meta path name"
		tempParam="$tempParam -param:rPathType=$rPathType"
	then
		echo "Kettle will modify the meta path name to be the same as the path name"
		tempParam="$tempParam -param:rPathType=$rPathType"
	)
	tempParam="$tempParam -param:rPath=$rPath"
fi

# goto current path
function fcd() {
  cd $1
}
fcd "$current_path"

# print info
[ $interactive -eq 1 ] && clear
echo "==========================================================="
echo "Kettle engine path is: $pdi_path"
echo "Kettle copy params is: $tempParam"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command run
c="$pdi_path/kitchen.sh -file:$current_path/Repository/CopyFileRepositoryAll.kjb $tempParam"
[ $interactive -ne 1 ] && echo "$c"
$c


# done
code=$?
if [ "$code" -eq "0" ]
then
    echo "Ok, run done!"
else
    echo "Sorry, some error make failure!"
fi


# end
if [ $interactive -eq 1 ] 
then
    read -p "Press enter to continue"
    exit $code
else
    exit $code
fi