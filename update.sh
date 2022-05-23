#!/bin/bash

DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(realpath "$DIR")
pushd "$DIR"
git checkout develop && git pull
popd
