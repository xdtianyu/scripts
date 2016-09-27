#!/bin/bash

echo $(date)

PWD="$(dirname $0)"

echo "$PWD"

cd "$PWD" || exit 1

PYTHONIOENCODING=utf-8:surrogateescape venv/bin/python free_book.py
