#!/bin/bash
# CODER BY xiaoyao9184 1.0
# TIME 2018-12-28
# FILE RUN_REPOSITORY_JOB_OR_TRANSFORMATION
# DESC run a job or transformation in filesystem repository
# PARAM params for the job or transformation 
#   1: ProfileName
# --------------------
# CHANGE 2019-1-4
# fix interactive check
# CHANGE 2020-5-19
# fix error when using named parameters
# --------------------


# var

tip="Kettle-Project-Toolbox: Run kitchen or pan"
ver="1.0"
# interactive
[[ -t 0 || -p /dev/stdin ]] && interactive=1 || interactive=0
# current info
current_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_script_name="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
current_script_name="${current_script_name%.*}"
# tip info
echo_rName="Need input kettle repository name!"
eset_rName="Please input kettle repository name:"
echo_jName="Need input kettle repository job or transformation name!"
eset_jName="Please input kettle repository job or transformation name:"
echo_jFile="The kettle job path is:"
echo_pList="Enter parameters setting script!"
echo_kCommand="Run job(1) or transformation(2)?"
# set kettle environment
if [ -f "$current_path/SET_ENVIRONMENT.sh" ]
then
    source "$current_path/SET_ENVIRONMENT.sh"
fi
# default param
rName=$KETTLE_REPOSITORY
jName=""
pList=""
kCommand=""
# logging level (Basic, Detailed, Debug, Rowlevel, Error, Nothing) or set position parameter 1
loglevel=Detailed


# title

echo -e '\033]2;'$tip $ver'\007'
echo "$tip"
echo "Can be closed after the run ends"
echo "..."


# check

# repository name
if [ -z $rName ]
then
    [ $interactive -ne 1 ] && echo "miss param:rName in non-interactive mode! exit"; exit 1
    echo $echo_rName
    read -p "$eset_rName" rName
fi

# job or transformation name
function finding()
{
    path=$1
    fileName=$2
    extName=$3
    # echo "finding file in this path: $fileName.$extName"
    if [ -f "$path/$fileName.$extName" ]
    then
        echo "$fileName"
    else
        fileName=$(echo $fileName | sed -e "s/\./\//g")
        # echo "finding file in sub path: $fileName.$extName"
        if [ -f "$path/$fileName.$extName" ]
        then
            echo "$fileName"
            # echo ""
        fi
    fi
}
if [ -z "$jName" ]
then
    jName=$(finding "$current_path" "$current_script_name" "kjb")
    kCommand="kitchen.sh"
fi
if [ -z "$jName" ]
then
    jName=$(finding "$current_path" "$current_script_name" "ktr")
    kCommand="pan.sh"
fi
if [ -z "$jName" ]
then
    [ $interactive -ne 1 ] && echo "miss param:jName in non-interactive mode! exit"; exit 1
    echo $echo_jName
    read -p "$eset_jName" jName
    kCommand=""
fi

# command is use kitchen or pan
if [ -z "$kCommand" ]
then
    echo "$echo_kCommand"
    select opt in "Job" "Transformation"
    do
        case $opt in
            "Job") 
                kCommand="kitchen.sh"
                break
                ;;
            "Transformation")
                kCommand="pan.sh"
                break
                ;;
            *) 
                echo "$echo_kCommand"
                ;;
        esac
    done
fi

# param
if [ $2 ]
then
    pList="-param:ProfileName=$2"
    loglevel=$1
elif [ $1 ]
then
    pList="-param:ProfileName=$1"
fi
if [ -f "$current_path/$current_script_name.SET_PARAM.sh" ]
then
    echo "$echo_pList $current_script_name.SET_PARAM.sh"
    source "$current_path/$current_script_name.SET_PARAM.sh"
fi

# log
time=$(date +%Y-%m-%d_%H-%M-%S)
logfile="$current_path/log/$current_script_name$time.log"


# begin

# goto engine
parent_path="$(dirname "$current_path")"
function fcd() {
  cd $1
}
fcd "$parent_path/data-integration"

# print info
[ $interactive -eq 1 ] && clear
echo "==========================================================="
echo "Kettle engine path is: $parent_path/data-integration"
echo "Kettle project path is: $current_path"
echo "Kettle command is: $kCommand"
echo "Kettle run it: $rName:$jName"
echo "Kettle parameters is: $pList"
echo "Kettle log level is: $loglevel"
echo "Kettle log location is: $logfile"
echo "==========================================================="
echo "Running...      Ctrl+C for exit"

# create command
c="$kCommand -rep:$rName -user:admin -pass:admin -level:$loglevel -job:$jName $pList"
[ $interactive -ne 1 ] && echo "$c"

# log output
if [ $JENKINS_HOME ]
then
    echo "Used in Jenkins no log file!"
    bash $c
else
    bash $c &> "$logfile"
fi

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
