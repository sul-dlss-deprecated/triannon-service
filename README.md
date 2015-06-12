[![Build Status](https://travis-ci.org/sul-dlss/triannon-service.svg?branch=master)](https://travis-ci.org/sul-dlss/triannon-service) [![Dependency Status](https://gemnasium.com/sul-dlss/triannon.svg)](https://gemnasium.com/sul-dlss/triannon)

## Triannon-Service

An essentially empty Rails app used for deploying the [triannon](https://github.com/sul-dlss/triannon) gem.  Triannon stores [OpenAnnotation](http://www.openannotation.org/) data in [Fedora4](http://fcrepo.org/).  Note that it is important to set up caching for jsonld context documents and this is documented in README for triannon gem (and is set up for this app).

## Configuration

We deploy this app with Capistrano.  If you are deploying it manually, note that you will need to do the following:
1. Install the gems
`bundle install`

2. Edit the `config/triannon.yml` file:
* `ldp:` Properties of LDP server
  * `url:` the baseurl of LDP server
  * `uber_container:` name of an LDP Basic Container holding specific anno containers
  * `anno_containers:`  (the names of LDP Basic Containers holding individual annos)
* `solr_url:` Points to the baseurl of Solr instance configured for Triannon
* `triannon_base_url:` Used as the base url for all annotations hosted by your Triannon server.  Identifiers from the LDP server will be appended to this base-url.  Generally something like "https://your-triannon-rails-box/annotations", as "/annotations" is added to the path by the Triannon gem

3. Generate the root annotation containers on the LDP server
```console
$ rake triannon:create_root_containers
```

This will generate the uber_container and the anno_containers (aka 'root containers') under the uber_container.

  NOTE:  you MUST create the root containers before creating any annotations.  All annotation MUST be created as a child of a root container.

## Client Interactions with Triannon app

### Get a list of annos
as a IIIF Annotation List (see http://iiif.io/api/presentation/2.0/#other-content-resources)

* `GET`: `http://(host)/annotations/search?targetUri=some.url.org`

Search Parameters:
* `targetUri` - matches URI for target, with or without http or https scheme prefix
* `bodyUri` - matches URI for target, with or without http or https scheme prefix
* `bodyExact` - matches body characters exactly
* `bodyKeyword` - matches terms in body characters
* `motivatedBy` - matches fragment part of motivation predicate URI, e.g.  commenting, tagging, painting
* `anno_root` - matches the root container of the result annos

* use HTTP `Accept` header with mime type to indicate desired format
  * default:  jsonld
    * `Accept`: `application/ld+json`
  * also supports turtle, rdfxml, json, htmls
    * `Accept`: `application/x-turtle`

### Get a list of annos in a particular root container
as a IIIF Annotation List (see http://iiif.io/api/presentation/2.0/#other-content-resources)

* `GET`: `http://(host)/annotations/(root container)/search?targetUri=some.url.org`

Search Parameters as above.

* use HTTP `Accept` header with mime type to indicate desired format, as above

### Get a particular anno
`GET`: `http://(host)/annotations/(root container)/(anno_id)`

NOTE:  you may need to URL encode the anno_id (e.g. "6f%2F0e%2F79%2F92%2F6f0e7992-83f5-4f31-8bb7-94a23465fdfb" instead of "6f/0e/79/92/6f0e7992-83f5-4f31-8bb7-94a23465fdfb"), particularly from a web browser.

* use HTTP `Accept` header with mime type to indicate desired format
  * default:  jsonld
    * indicate desired context url in the HTTP Accept header thus:
      * `Accept`: `application/ld+json; profile="http://www.w3.org/ns/oa-context-20130208.json"`
	  * `Accept`: `application/ld+json; profile="http://iiif.io/api/presentation/2/context.json"`
  * also supports turtle, rdfxml, json, html
    * indicated desired context url for jsonld as json in the HTTP Link header thus:
      * `Accept`: `application/json`
      * `Link`: `http://www.w3.org/ns/oa.json; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"`
        * note that the "type" part is optional and refers to the type of the rel, which is the reference for all json-ld contexts.
  * see https://github.com/sul-dlss/triannon/blob/master/app/controllers/triannon/annotations_controller.rb #show method for mime formats accepted

#### JSON-LD context
You can request IIIF or OA context for jsonld.

The correct way:
* use HTTP `Accept` header with mime type and context url:
  * `Accept`: `application/ld+json; profile="http://www.w3.org/ns/oa-context-20130208.json"`
  * `Accept`: `application/ld+json; profile="http://iiif.io/api/presentation/2/context.json"`

You can also use this method (with the correct HTTP Accept header):

* `GET`: `http://(host)/annotations/(root)/(anno_id)?jsonld_context=iiif`
* `GET`: `http://(host)/annotations/(root)/(anno_id)?jsonld_context=oa`

Note that OA (Open Annotation) is the default context if none is specified.

### Create an anno

Note that annos must be created in an existing root container.

`POST`: `http://(host)/annotations/(root container)`
* the body of the HTTP request should contain the annotation, as jsonld, turtle, or rdfxml
* the `Content-Type` header should be the mime type matching the body
* the anno to be created should NOT already have an assigned @id
* to get a particular format back, use the HTTP `Accept` header
  * to get a particular context for jsonld, do one of the following:
    * `Accept`: `application/ld+json; profile="http://www.w3.org/ns/oa-context-20130208.json"`
    * `Accept`: `application/ld+json; profile="http://iiif.io/api/presentation/2/context.json"`
  * to get a particular jsonld context for jsonld as json, specify it in the HTTP Link header thus:
    * `Accept`: `application/json`
    * `Link`: `http://www.w3.org/ns/oa.json; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"`
      * note that the "type" part is optional and refers to the type of the rel, which is the reference for all json-ld contexts.

### Delete an anno
`DELETE`: `http://(host)/annotations/(root container)/(anno_id)`

NOTE:  you may need to URL encode the anno_id (e.g. "6f%2F0e%2F79%2F92%2F6f0e7992-83f5-4f31-8bb7-94a23465fdfb" instead of "6f/0e/79/92/6f0e7992-83f5-4f31-8bb7-94a23465fdfb")

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
