#!/usr/bin/env bash
# NAME: AWS Easy Snapshot Maker
# DESC: Automates the snapshot creation process, aslo list snapshots and volumes
# GIT:
# URL: 
# 
# Copyright (c) 2013 Jon Retting
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
VERSION="0.01"

usage() {
	echo "AWS Easy Snapshot Maker -- v${VERSION}
Usage:   create-snap [-L | -V] | <tag-name> [-z] [-a=N] [-d] [-q] [-p] [-h] [-v]
Example: create-snap my-snap-tag -z us-west-1 -a 2
-r     --region       AWS Region (required if $EC2_URL env var is not set)
-L     --list         List snapshots (needs opts, stdout: snap-id, tag:Name, date created)
-V     --volumes      List volumes (needs opts, stdout: vol-id, tag:Name, mount-state/instance-id)
-i     --instance     Looks for tag:Name=VALUE for Instances uses root vol (default is Volumes)
-a=N   --archive=N    Keep N snapshots removes >N old (default=0, old volumes must have same <tag-name>)
-d     --dryrun       Do a test run without making changes
-p     --prompt       Prompts to continue/cancel after each execution process
-q     --quiet        Dont output anything to stdout
-E     --email        Email job start and completion or failure information
-F     --fail         Exit script with error on all warning (default is to continue)
-v     --verbose      Output more information
-h     --help         Display this cruft
       --version      Show version info
<tag-name> is the value of the \"Name\" tag given to your volume or instance (without <>)
<tag-name> is required else if --list or --volumes is envoked
If tag-name is \" - \" asumes stdin piped for tag:Name=VALUE
Requires: \$AWS_ACCESS_KEY, \$AWS_SECRET_KEY, and \$JAVA_HOME environmental variables
Dependencies: AWS CLI Tools"
}
output() {
	case $1 in
		message)	echo -ne "$2"		;;
		 result)	echo "$2"			;;
		   info)	logger -s -p local0.info -t 'esm.sh' "$2"			;;
		   warn)	logger -is -p local0.warn -t 'esm.sh' "$2"			;;
	     optmis)	echo "Missing option value :: $2"; exit 1			;;
		 badopt)	echo "Unknown option given :: $2"; exit 1			;;
		  error)	logger -is -p local0.err -t 'esm.sh' "$2"; exit 1	;;
	esac
}
long-opt() {
	[[ -z "$1" ]] && output optmis "--$2"
	OPTIND=$(($OPTIND + 1))
}

get-options() {
	local opts=":a:l:-:"
	while getopts "$opts" OPTIONS; do
		case "${OPTIONS}" in
			-)	case "${OPTARG}" in
					long)	LONG="${!OPTIND}"; long-opt "${!OPTIND}" ${OPTARG}	;;
			   	   along)	ALONG="${!OPTIND}"; long-opt "${!OPTIND}" ${OPTARG}	;;
				       *)	output badopt "--${OPTARG}"		;;
				esac
			;;
			l)	SHORT="$OPTARG"				;;
			a)	ASHORT="$OPTARG"			;;
			:)	output optmis "-$OPTARG"	;;
			*)	output badopt "-$OPTARG"	;;
		esac
	done
}
get-name() {
	local args="$@"
	NAME=$(echo "$args" | sed)
}


SHORT=
LONG=
SLONG=
ASHORT=

get-name-value "$@"

get-options "$OPTIONS"

shift $((OPTIND - 1))

echo $@

echo $ALONG
exit 0