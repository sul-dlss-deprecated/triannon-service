[![Build Status](https://travis-ci.org/sul-dlss/triannon-service.svg?branch=master)](https://travis-ci.org/sul-dlss/triannon-service) [![Dependency Status](https://gemnasium.com/sul-dlss/triannon.svg)](https://gemnasium.com/sul-dlss/triannon)

## Triannon-Service

An essentially empty Rails app used for deploying the [triannon](https://github.com/sul-dlss/triannon) gem.  Triannon stores [OpenAnnotation](http://www.openannotation.org/) data in [Fedora4](http://fcrepo.org/).

# Client Interactions with Triannon app

### Get a list of annos
* `GET`: `http://(host)/`
* `GET`: `http://(host)/annotations`

### Get a particular anno
`GET: http://(host)/annotations/(anno_id)`

* use HTTP Accept header with mime type to indicate desired format
  * default:  jsonld
    * indicate desired context url in the HTTP Accept header thus:
      * Accept: application/ld+json; profile="http://www.w3.org/ns/oa-context-20130208.json" 
	  * Accept: application/ld+json; profile="http://iiif.io/api/presentation/2/context.json"
  * also supports turtle, rdfxml, json, html
    * indicated desired context url for jsonld as json in the HTTP Link header thus:
      * Accept: application/json
      * Link: http://www.w3.org/ns/oa.json; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
        * note that the "type" part is optional and refers to the type of the rel, which is the reference for all json-ld contexts.
  * see https://github.com/sul-dlss/triannon/blob/master/app/controllers/triannon/annotations_controller.rb #show method for mime formats accepted

#### JSON-LD context
You can request IIIF or OA context for jsonld.

The correct way:
* use HTTP Accept header with mime type and context url:
  * Accept: application/ld+json; profile="http://www.w3.org/ns/oa-context-20130208.json"
  * Accept: application/ld+json; profile="http://iiif.io/api/presentation/2/context.json"

You can also use either of these methods (with the correct HTTP Accept header):

* `GET`: `http://(host)/annotations/iiif/(anno_id)`
* `GET`: `http://(host)/annotations/(anno_id)?jsonld_context=iiif`

* `GET`:` http://(host)/annotations/oa/(anno_id)`
* `GET`: `http://(host)/annotations/(anno_id)?jsonld_context=oa`

Note that OA (Open Annotation) is the default context if none is specified.

### Create an anno
`POST`: `http://(host)/annotations`
* the body of the HTTP request should contain the annotation, as jsonld, turtle, or rdfxml
* the Content-Type header should be the mime type matching the body
* the anno to be created should NOT already have an assigned @id
* to get a particular format back, use the HTTP Accept header
* to get a particular format back, use the HTTP Accept header
  * to get a particular context for jsonld, do one of the following:
    * Accept: application/ld+json; profile="http://www.w3.org/ns/oa-context-20130208.json"
    * Accept: application/ld+json; profile="http://iiif.io/api/presentation/2/context.json"
  * to get a particular jsonld context for jsonld as json, specify it in the HTTP Link header thus:
    * Accept: application/json
    * Link: http://www.w3.org/ns/oa.json; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      * note that the "type" part is optional and refers to the type of the rel, which is the reference for all json-ld contexts.

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
