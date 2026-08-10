#!/bin/bash
ps -eo pid=,comm= --sort=-%cpu | awk 'NR==1 {print $1, $2}'
