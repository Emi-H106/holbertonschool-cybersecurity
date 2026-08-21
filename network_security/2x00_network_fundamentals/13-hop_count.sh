#!/bin/bash
traceroute -n "$1" 2>/dev/null | tail -n +2 | wc -l
