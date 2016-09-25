#!/bin/bash

echo $(date)

PWD="$(dirname $0)"

echo "$PWD"

cd "$PWD" || exit 1

venv/bin/python upload.py
