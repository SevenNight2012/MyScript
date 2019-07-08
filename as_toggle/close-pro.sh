#!/bin/bash
parent=$(dirname $0)
osascript "${parent}"/close.scpt "$1"
