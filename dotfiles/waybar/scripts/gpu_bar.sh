#!/bin/bash

# Block levels: 0% -> ▁ ... 100% -> █
blocks=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

# Get usage and temperature
output=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | head -n1)

# Split and clean
usage=$(echo "$output" | cut -d',' -f1 | tr -d '[:space:]')
temp=$(echo "$output" | cut -d',' -f2 | tr -d '[:space:]')

# Fallback if empty
if [[ -z "$usage" || -z "$temp" ]]; then
  echo '{"text": "󰍛", "tooltip": "NVIDIA GPU not active"}'
  exit 0
fi

# Make sure usage is a number
if ! [[ "$usage" =~ ^[0-9]+$ ]]; then
  echo '{"text": "?", "tooltip": "Invalid GPU usage"}'
  exit 1
fi

# Map usage to index
(( usage < 0 )) && usage=0
(( usage > 100 )) && usage=100
index=$(( usage * 8 / 100 ))
(( index > 7 )) && index=7

block="${blocks[$index]}"

echo "{\"text\": \"$block\", \"tooltip\": \"NVIDIA GPU: ${usage}% @ ${temp}°C\"}"