[![Dependency Status](https://gemnasium.com/sul-dlss/triannon.svg)](https://gemnasium.com/sul-dlss/triannon)

# Triannon-Service

An essentially empty Rails app used for deploying the triannon gem.  Triannon stores OpenAnnotation data in Fedora4.

# To Update Triannon
* Cut a new release of the Triannon gem.
* In your local instance of THIS code, 
```console
$ bundle update triannon
$ git push origin master
$ cap development deploy
```

You will see

```console
Please enter home_parent_dir (Enter the full path of the parent of the home dir (e.g. /home)):
Please enter user (enter the app username):
Please enter deploy_host (Enter in the server you are deploying to. do not include .stanford.edu):
```

You may need to ssh to the target box to learn the correct answers to these questions ...
