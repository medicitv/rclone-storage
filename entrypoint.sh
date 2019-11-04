#!/bin/sh

PERIOD=${PERIOD:-30}
READY_FILE=${READY_FILE:-/.ready}
CONFIG_FILE="--config /tmp/rclone.conf"

if [ -n "$UID" ]; then
	GID=${GID:-${UID}}
	group=$(getent group $GID | cut -d ':' -f 1)
	if [ -z "$group" ]; then
		addgroup -g ${GID} user
		group="user"
	fi
	user=$(getent passwd $UID | cut -d ':' -f 1)
	if [ -z "$user" ]; then
		adduser -u ${UID} -G "${group}" -D user
		user="user"
	fi
	chown -R $user:$group /storage
	SU="su $user -c"
else
	SU="eval"
fi

function init() {
	echo  "init"

	$SU "touch /tmp/rclone.conf"
	$SU "rclone copy ${CONFIG_FILE} ${ARGS} ${REMOTE} /storage" || return 1
	$SU "touch /storage${READY_FILE}"
}

function sync() {
	while true; do
		sleep ${PERIOD}
		echo "sync"
		$SU "rclone sync ${CONFIG_FILE} --exclude ${READY_FILE} ${ARGS} /storage ${REMOTE}"
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
