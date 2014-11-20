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
