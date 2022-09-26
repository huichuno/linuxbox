#!/bin/bash

source conf

# delete existing .config file
if [[ -f ".config" ]]; then
  echo "delete existing .config file"
  rm -f .config
fi

if [[ $CONFIG_URL == http* || $CONFIG_URL == HTTP* ]]; then
  echo "download $CONFIG_URL"
  curl $CONFIG_URL -o .config
fi

# local file path
if [[ $CONFIG_URL == *kernel-config* ]]; then
  echo "cp $CONFIG_URL"
  cp $CONFIG_URL .config
fi
