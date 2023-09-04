#!/usr/bin/env bash

set -x
hugo && cp docs/CNAME public/ && rm -rf docs/ && mv public/ docs/

