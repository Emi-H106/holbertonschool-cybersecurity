#!/bin/bash
ip=$(dig astralis-cloud.example A +short +time=3 +tries=1 | head -n 1)