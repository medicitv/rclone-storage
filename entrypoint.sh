#!/bin/sh

RCLONE=rclone
PERIOD=${PERIOD:-30}
READY_FILE=${READY_FILE:-/.ready}

function init() {
	echo  "init"
	touch $($RCLONE config file)
	$RCLONE copy ${ARGS} ${REMOTE} /storage || return 1
	touch /storage${READY_FILE}
}

function sync() {
	while true; do
		sleep ${PERIOD}
		echo "sync"
		$RCLONE sync --exclude ${READY_FILE} ${ARGS} /storage ${REMOTE}
	done
}

case $0 in

	/bin/check)
		echo "check"
		test -f /storage${READY_FILE}
		;;

	*)
		init && sync
		;;
esac
