#!/usr/bin/env bash

set -x
rm -rf public/ &&\
rm -rf docs/ &&\
hugo &&\
cp `ls public/offline-search-index*` public/offline-search-index.json &&\
echo -n "buzzpirat.com" > public/CNAME &&\
mv public/ docs/ &&\
git add . &&\
git commit -a -m 'commit'
hugo server
