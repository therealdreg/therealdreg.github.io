#!/usr/bin/env bash

set -x
rm -rf public/ &&\
rm -rf docs/ &&\
hugo
offsrch=`ls docs/offline-search-index*` &&\
mv $offsrch docs/offline-search-index.json &&\
exit 1
echo -n "buzzpirat.com" > public/CNAME &&\
mv public/ docs/ &&\
git add . &&\
git commit -a -m 'commit'
hugo server
