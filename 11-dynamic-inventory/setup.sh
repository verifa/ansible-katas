#!/bin/bash

kata="$(basename $(pwd))"

#for docker to know where to mount to
echo "EXERCISE_PATH=$(pwd)" > ../.utils/.env

cd ../.utils
. setup.sh $kata multiple-hosts
cd - > /dev/null

