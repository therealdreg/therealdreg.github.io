#!/usr/bin/env bash

set -x
rm -rf public/ &&\
rm -rf docs/ &&\
hugo &&\
echo -n "buzzpirat.com" > public/CNAME &&\
mv public/ docs/ &&\
git add . &&\
git commit -a -m 'commit'
