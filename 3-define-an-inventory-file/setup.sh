#!/bin/bash

echo "EXERCISE_PATH=$(pwd)" > ../utils/.env

cd ../utils
. setup.sh multiple-hosts
cd -
