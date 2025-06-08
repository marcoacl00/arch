#!/bin/bash
usage=$(grep 'cpu ' /proc/stat | awk '{u=($2+$4)*100/($2+$4+$5)} END {printf "%d", u}')
bar=$(printf "%-${usage}s" "" | tr ' ' '*')
echo "{\"text\": \"CPU: ${bar:0:20}\", \"class\": \"cpu-bar\", \"percentage\": $usage}"
