#!/bin/bash
sudo nft flush ruleset; (sleep 300 && sudo "$0") &