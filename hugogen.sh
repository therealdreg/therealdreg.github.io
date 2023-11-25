#!/usr/bin/env bash

set -x
hugo && cp docs/CNAME public/ && rm -rf docs/ && mv public/ docs/ && git add . && git commit -a -m 'commit'
