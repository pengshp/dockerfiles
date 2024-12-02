#! /bin/sh
#
# entrypoint.sh

set -e

[[ "$DEBUG" == "true" ]] && set -x

adduser -h /data -s /bin/sh -D torrent
groupmod -g ${GID} -o torrent && usermod -u ${UID} -g ${GID} -o torrent

mkdir -p /data/torrents /data/.watch /data/.session /var/tmp/nginx

[[ -f /data/.rtorrent.rc ]] || cp /etc/rtorrent.rc /data/.rtorrent.rc
[[ -f /data/scgi.socket ]] || touch /data/scgi.socket
[[ -f /data/.session/rtorrent.lock ]] && rm -f /data/.session/rtorrent.lock

htpasswd -b -c /var/www/rutorrent/.htpasswd $USERNAME ${PASSWORD:-$(hostname)}

chown -R torrent:torrent /data
chown -R torrent:torrent /var/www
chown -R torrent:torrent /var/lib/nginx
chown -R torrent:torrent /var/tmp/nginx

exec "$@"
