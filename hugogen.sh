#!/usr/bin/env bash

set -x
rm -rf public/ &&\
hugo &&\
echo -n "buzzpirat.com" > public/CNAME &&\
git add . &&\
git commit -a -m 'commit'
