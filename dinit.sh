#!/bin/bash
if [ $(id -g "${USER}") -lt 1000 ]; then
  gid=$(for group in $(id -G); do echo $group; done | sort --human-numeric-sort | tail -1)
else
  gid=$(id -g "${USER}")
fi
if [ ! -d "build-web" ]; then
  chown :"$gid" .
  chmod 775 .
  chmod g+s .
  mkdir build-web
  chown :"$gid" build-web
  chmod 775 build-web
  chmod g+s build-web
fi
if [ -d ".git" ]; then
  if [ -e ".gitmodules" ]; then
    git submodule update --init --recursive
  fi
fi

docker build \
  --build-arg user="$(id -u "${USER}")" \
  --build-arg group="$gid" \
  -t tpm-js-builder-image .

