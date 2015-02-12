[![Build Status](https://travis-ci.org/sul-dlss/triannon-service.svg?branch=master)](https://travis-ci.org/sul-dlss/triannon-service) [![Dependency Status](https://gemnasium.com/sul-dlss/triannon.svg)](https://gemnasium.com/sul-dlss/triannon)

## Triannon-Service

An essentially empty Rails app used for deploying the [triannon](https://github.com/sul-dlss/triannon) gem.  Triannon stores [OpenAnnotation](http://www.openannotation.org/) data in [Fedora4](http://fcrepo.org/).

# Client Interactions with Triannon app

### Get a list of annos
* `GET`: `http://(host)/`
* `GET`: `http://(host)/annotations`

### Get a particular anno
`GET: http://(host)/annotations/(anno_id)`

use HTTP Accept header with mime type to indicate desired format
* default:  jsonld
* also supports turtle, rdfxml, html
* see [annotations#show](https://github.com/sul-dlss/triannon/blob/master/app/controllers/triannon/annotations_controller.rb) for other mime formats accepted

#### JSON-LD context
You can request IIIF or OA context for jsonld.  You can use either of these methods (with the correct HTTP Accept header):

* `GET`: `http://(host)/annotations/iiif/(anno_id)`
* `GET`: `http://(host)/annotations/(anno_id)?jsonld_context=iiif`

* `GET`:` http://(host)/annotations/oa/(anno_id)`
* `GET`: `http://(host)/annotations/(anno_id)?jsonld_context=oa`

Note that OA (Open Annotation) is the default context if none is specified.

### Create an anno
`POST`: `http://(host)/annotations`
* the body of the HTTP request should contain the annotation, as jsonld, turtle, or rdfxml
* the anno to be created should NOT already have an assigned @id

### Delete an anno
`DELETE`: `http://(host)/annotations/(anno_id)`


# To Update Triannon in this app
* Cut a new release of the Triannon gem.
* In your local instance of THIS code,
```console
$ bundle update triannon
$ git commit -m "updated triannon gem to release x.y.z" Gemfile.lock ...
$ git push origin master
$ cap (development) deploy
```

You will see

```console
Please enter home_parent_dir (Enter the full path of the parent of the home dir (e.g. /home)):
Please enter user (enter the app username):
Please enter deploy_host (Enter in the server you are deploying to. do not include .stanford.edu):
```

You may need to ssh to the target box to learn the correct answers to these questions ...
