#!/usr/bin/env bash
# GH_TOKEN should be an env variable that has a Github Personal token with access to the public repos
# Target repo and branch to push the website
TARGET_REPO=mnbvcxz010308/project-alpha.git
BRANCH=gh-pages

# Where does pelican output the website
PELICAN_OUTPUT_FOLDER=output
echo "$TRAVIS_PULL_REQUEST"

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    echo -e "Starting to deploy to Github Pages\n"
    echo "Reached Here"
    if [ "$TRAVIS" == "true" ]; then
        git config --global user.email "travis@travis-ci.org"
        git config --global user.name "Travis"
    fi
    echo "Reached Here 2"
    # using token clone target gh-pages repo and branch
    git clone --quiet --branch=$BRANCH https://${GH_TOKEN}@github.com/$TARGET_REPO built_website > /dev/null
    # go into directory and copy data we're interested in to that directory
    cd built_website
    rsync -rv --exclude=.git  ../$PELICAN_OUTPUT_FOLDER/* .
    # add, commit and push files
    git add -f .
    git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to Github Pages"
    git push -fq origin $BRANCH > /dev/null
    echo "Deploy completed"
fi
