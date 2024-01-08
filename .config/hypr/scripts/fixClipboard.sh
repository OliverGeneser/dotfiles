#!/usr/bin/env bash

id="$(cliphist list | tofi)"
test -z "$id" && exit

cliphist decode <<<"$id" | wl-copy