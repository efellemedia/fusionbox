#!/usr/bin/env bash

fusionboxRoot=~/.fusionbox

mkdir -p "$fusionboxRoot"

cp -i stubs/Fusionbox.yaml "$fusionboxRoot/Fusionbox.yaml"

echo "Fusionbox initialized!"
