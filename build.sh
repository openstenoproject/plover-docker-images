#!/bin/sh

repo='plover/packpack'
image="$1"
shift

image_size()
{
  docker images --format='{{.Size}}' "$repo:$image"
}

previous_size="$(image_size)"
docker build -t "$repo:$image" "$image" "$@"
code=$?
if [ $code -eq 0 -a -n "$previous_size" ]
then
  echo "Image size: $previous_size -> $(image_size)"
fi
exit $code
