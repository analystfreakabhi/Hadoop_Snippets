
. ./setup_hdp.ksh

#####################################################
##            setup environemnt
####################################################

. setup_hdp.ksh

function write_message {
  if [[ $# != 2 ]]; then
    print -u2 "Usage write_message : write_message <message_type> <command> "
    return 1
  fi

  severity=$1
  echo $severity : $USER : $(date '+%m/%d/%Y %H:%M:%S'
) : "+++++ $2 +++++ "
}

function safeExecCmd
{
	cmd=$1
	write_message info "Executing command $1"
	eval $cmd
	l_rc=$?
	if [ "$l_rc" != "0" ];then
		write_message error "Failed Execution $cmd"
		exit $l_rc
	fi	
}

function parse_arguments 
{
	#unset params
	parms_entered=$#
	#echo $parms_entered

	while [ ! -z "$[1]" ]
	do
		case "${1}" in 
			"-SOURCE_TBL")
			shift
			SOURCE_TABLE="${1}"
			shift;;
			"-SPLIT_BY")
			shift
			SPLIT_BY="${1}"
			shift;;
        	*)
            #echo "unexpected param"
            break
		esac
	done		
}


parse_arguments $@

write_message info "Job Execution started "
write_message info "exported value DATAPATH = ${datapath}"
write_message info "exported value SOURCE_TABLE = ${SOURCE_TABLE}"
write_message info "exported value SPLIT_BY = ${SPLIT_BY}"


safeExecCmd "hadoop fs -ls ${datapath}"

write_message info "Job Execution Completed "

