#!/bin/sh -e

# shellcheck disable=SC2230
tag="$(cat plugin.yaml | grep "version" | cut -d '"' -f 2)"
echo "Tagging helm-test with v${tag} ..."

git checkout master
git pull
git tag -a -m "Release v$tag" "v$tag"
git push origin refs/tags/v"$tag"
