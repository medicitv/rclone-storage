#!/bin/sh

RCLONE=/root/rclone
PERIOD=${PERIOD:-30}
READY_FILE=${READY_FILE:-/.ready}

function init() {
	touch $($RCLONE config file)
	$RCLONE copy ${ARGS} ${REMOTE} /storage
	touch /storage${READY_FILE}	
}

function sync() {
	while true; do
		sleep ${PERIOD}
		$RCLONE sync --exclude ${READY_FILE} ${ARGS} /storage ${REMOTE}
	done	
}

case $0 in 

	/bin/check)
		test -f /storage${READY_FILE}
		;;

	*)
		init
		sync
		;;
esac