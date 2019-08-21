#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && echo "No GITHUB_PAT" && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && echo "Not on master branch" && exit 0

git config --global user.email "pecanproj@gmail.com"
git config --global user.name "TRAVIS-DOC-BUILD"

git clone https://${GITHUB_PAT}@github.com/PecanProject/bety-documentation.git book-output

cd book-output

rsync -av --delete ../_book/ ./dataaccess/
git add --all *
git commit -m "Update the book -- dataaccess" || true
git push -q origin master
