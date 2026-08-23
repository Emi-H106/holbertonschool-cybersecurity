#!/bin/bash
dig +trace "$1" | awk '$4 == "A" {print $5; exit}'
