#!/bin/bash
read total used <<< $(free | awk '/Mem:/ {print $2, $3})'
usage=$(( used * 100 / total ))
bar=$(printf "%-${usage}s" "" | tr ' ' '█')
echo "{\"text\": \"RAM: ${bar:0:20}\", \"class\": \"ram-bar\", \"percentage\": $usage}"
