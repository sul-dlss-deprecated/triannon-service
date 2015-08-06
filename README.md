[![Build Status](https://travis-ci.org/sul-dlss/triannon-service.svg?branch=master)](https://travis-ci.org/sul-dlss/triannon-service) [![Dependency Status](https://gemnasium.com/sul-dlss/triannon.svg)](https://gemnasium.com/sul-dlss/triannon)

## Triannon-Service

An essentially empty Rails app used for deploying the [triannon](https://github.com/sul-dlss/triannon) gem.  Triannon stores [OpenAnnotation](http://www.openannotation.org/) data in [Fedora4](http://fcrepo.org/).  Note that it is important to set up caching for jsonld context documents and this is documented in README for triannon gem (and is set up for this app).

## Configuration

This app is commonly deployed with Capistrano.  If deploying it manually, do the
following:

1. Install the gems
```sh
bundle install
```

2. Edit the `config/triannon.yml` file, see https://github.com/sul-dlss/triannon#configuration

3. Generate the root annotation containers on the LDP server
```sh
rake triannon:create_root_containers
```

This will generate the parent `uber_container` and it's child `anno_containers`.
These containers MUST be created before creating annotations because annotations
MUST be created as a child of an `anno_container`.

## Client Interactions with Triannon app

See https://github.com/sul-dlss/triannon


# To Update Triannon in this app

* Release a new version of the Triannon gem
* In a clone of THIS project, run:
```sh
bundle update triannon
git add Gemfile.lock
git commit -m "updated triannon gem to release x.y.z"
git push origin master
cap development deploy # or another target
```

The `cap {target} deploy` process will prompt for details, i.e.
```
Please enter home_parent_dir (Enter the full path of the parent of the home dir (e.g. /home)):
Please enter user (enter the app username):
Please enter deploy_host (Enter in the server you are deploying to. do not include .stanford.edu):
```

You may need to ssh to the target box to learn the correct answers to these questions.

