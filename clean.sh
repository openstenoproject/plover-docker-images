#!/bin/sh

docker images -f dangling=true --format='{{.ID}}' |
xargs --no-run-if-empty docker rmi
