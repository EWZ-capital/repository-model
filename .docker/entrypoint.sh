#!/bin/bash

npm run dev:server &

/docker-entrypoint.sh

# filebeat modules enable nginx

# service filebeat start

nginx -g "daemon off;"
