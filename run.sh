#!/bin/bash
mkdir -p /app/{logs,eggs}
touch /app/scrapy.cfg
logparser -dir='/app/logs'  &
scrapyd --pidfile=
