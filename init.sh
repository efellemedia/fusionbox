#!/usr/bin/env bash

fusionboxRoot=~/.fusionbox

mkdir -p "$fusionboxRoot"

cp -i src/stubs/Fusionbox.yaml "$fusionboxRoot/Fusionbox.yaml"

echo "Fusionbox initialized! You will find your configuration file at $fusionboxRoot/Fusionbox.yaml"
