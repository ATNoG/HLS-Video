#!/bin/sh

echo "HLS_SERVER_MASTER_STREAM_URL = $HLS_SERVER_MASTER_STREAM_URL"

# If the environment variable is set, perform the replacement
if [ -n "$HLS_SERVER_MASTER_STREAM_URL" ]; then
    sed -i "s|http://localhost/hls/master.m3u8|$HLS_SERVER_MASTER_STREAM_URL|g" /var/www/html/index.html
fi

# Start nginx
nginx -g "daemon off;"