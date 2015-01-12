require "spec_helper"

describe ApplicationController do
  routes { Triannon::Engine.routes }

  it "root routes to triannon/annotations#index" do
    expect(:get => "/").to route_to("triannon/annotations#index")
  end
  
  it "annotations/annotations should NOT be routed" do
    expect(:get => "/annotations/annotations").to_not route_to("triannon/annotations#index")
    expect(:put => "/annotations/annotations").to_not be_routable
  end

  context 'show action' do
    it "get /annotations/:id routes to triannon/annotations#show" do
      expect(:get => "/annotations/1").to route_to("triannon/annotations#show", :id => "1")
    end
    it 'routes /annotation/iiif/:id (GET) to #show with jsonld_context of iiif in annotations controller' do
      expect(:get => "/annotations/iiif/666").to route_to(:controller => "triannon/annotations", :action => "show", :jsonld_context => "iiif", :id => "666")
    end
    it 'routes /annotation/oa/:id (GET) to #show with jsonld_context of oa in annotations controller' do
      expect(:get => "/annotations/oa/666").to route_to(:controller => "triannon/annotations", :action => "show", :jsonld_context => "oa", :id => "666")
    end
  end

  it "get /annotations routes to triannon/annotations#index" do
    expect(:get => "/annotations").to route_to("triannon/annotations#index")
  end

  it "post to /annotations routes to triannon/annotations#create" do
    expect(:post => "/annotations").to route_to("triannon/annotations#create")
  end

  it "get /annotations/new routes to triannon/annotations#new" do
    expect(:get => "/annotations/new").to route_to("triannon/annotations#new")
  end

  it "delete /annotations/:id routes to triannon/annotations#destroy" do
    expect(:delete => "/annotations/1").to route_to("triannon/annotations#destroy", :id => "1")
  end

  # TODO:  PUT not yet implemented
  it "put annotations/(:id) does NOT route to triannon/annotations/#update" do
    expect(:put => "/annotations/1").to_not route_to("triannon/annotations#update", :id => "1")
    expect(:put => "/annotations/1").to_not be_routable
  end

end
