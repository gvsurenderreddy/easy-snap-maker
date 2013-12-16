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
Usage:   create-snap [-L|-V] <tag-Name|-> [-z] [-a=N] [-d] [-q] [-p] [-h] [-v]
Example: create-snap my-snap-tag -z us-west-1 -a 2
-r     --region         AWS Region (required if $EC2_URL env var is not set)
-L     --list         List snapshots (needs opts, stdout: snap-id, tag:Name, date created)
-V     --volumes      List volumes (needs opts, stdout: vol-id, tag:Name, mount-state/instance-id)
-i     --instance     Looks for tag:Name=VALUE for Instances uses root vol (default is Volumes)
-a=N   --archive=N    Keep previous N snapshots removes older (default=0, requires uses tag:Name=VALUE)
-d     --dryrun       Do a test run without making changes
-p     --prompt       Prompts to continue/cancel after each execution process
-q     --quiet        Dont output anything to stdout
-E     --email        Email job start and completion or failure information
-F     --fail         Exit script with error on all warning (default is to continue)
-v     --verbose      Output more information
-h     --help         Display this cruft
       --version      Show version info
tag:Name=VALUE is required else if --list | --volumes
If tag-name is \" - \" asumes stdin piped for tag:Name=VALUE
Requires: $AWS_ACCESS_KEY, $AWS_SECRET_KEY and $JAVA_HOME environmental variables
Dependencies: AWS CLI Tools"
}
output() {
	case $1 in
		message)	echo -ne "$2"		;;
		 result)	echo "$2"			;;
		   info)	logger -s -p local0.info -t 'esm.sh' "$2"			;;
		   warn)	logger -is -p local0.warn -t 'esm.sh' "$2"			;;
		  error)	logger -is -p local0.err -t 'esm.sh' "$2"; exit 1	;;
	esac
}
get-long-options() {
	local OPTIONS="$1"
	case ${OPTIONS} in
		-archive)	VALUE="$2"	;;
	esac
}
get-options() {
	while getopts rLVia:dpqEFhv-: OPTIONS; do
		case "${OPTIONS}" in
			 -)	get-long-options "$1"	;;
			-h)	usage; exit 0			;;
		esac
	done
}

get-options

echo $VALUE

exit 0