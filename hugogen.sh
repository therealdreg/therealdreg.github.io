#!/usr/bin/env bash

set -x
hugo &&\
rm -rf docs/ &&\
mv public/ docs/ &&\
echo -n "buzzpirat.com" > docs/CNAME &&\
git add . &&\
git commit -a -m 'commit'
