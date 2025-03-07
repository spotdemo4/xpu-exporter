#!/bin/sh
export PYTHONUNBUFFERED=1
socket_folder=${XPUM_SOCKET_FOLDER:-/tmp}
rest_host=${XPUM_REST_HOST:-0.0.0.0}
rest_port=${XPUM_REST_PORT:-29999}

/usr/bin/xpumd -s ${socket_folder} & until [ -e ${socket_folder}/xpum_p.sock ]; do sleep 0.1; done
(cd /usr/lib/xpum/rest && XPUM_EXPORTER_NO_AUTH=1 XPUM_EXPORTER_ONLY=1 exec gunicorn --bind ${rest_host}:${rest_port} --worker-class gthread --threads 10 --worker-connections 1000 -w 1 'xpum_rest_main:main()')