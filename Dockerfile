FROM rclone/rclone

VOLUME /storage

COPY entrypoint.sh /bin/entrypoint
COPY entrypoint.sh /bin/check

ENTRYPOINT /bin/entrypoint