#!/bin/sh

set -e

repo='plover/packpack'
image="$1"
shift

image_size()
{
  docker images --format='{{.Size}}' "$repo:$image" || true
}

previous_size="$(image_size)"
docker build -t "$repo:$image" "$image" "$@" &&
# Tag intermediate stages so `./clean.sh` does not get rid of them.
sed -n 's/^FROM [^ ]\+\(:[^ ]\+\)\? AS \([^ ]\+\)$/\2/p' "$image/Dockerfile" |
tac | while read stage
do
  echo -n "Tagging stage $stage: "
  docker build --quiet --target="$stage" -t "$repo:$image-$stage" "$image" "$@"
done
code=$?
if [ -n "$previous_size" ]
then
  echo "Image size: $previous_size -> $(image_size)"
fi
exit $code
