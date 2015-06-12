require "spec_helper"

describe ApplicationController, :type => :routing do
  routes { Triannon::Engine.routes }

  it "root routes to triannon/search#find" do
    expect(:get => "/").to route_to("triannon/search#find")
  end

  it "get /annotations routes to triannon/search#find" do
    expect(:get => "/annotations").to route_to("triannon/search#find")
  end

  it "annotations/annotations should NOT be routed" do
    expect(:get => "/annotations/annotations").to_not route_to("triannon/annotations#index")
    expect(:put => "/annotations/annotations").to_not be_routable
  end

  context 'show action' do
    it "get /annotations/(root)/:id routes to triannon/annotations#show with params" do
      expect(:get => "/annotations/foo/1").to route_to(controller: "triannon/annotations", action: "show", anno_root: "foo", id: '1')
    end
    it '/annotation/iiif/:id (GET) routes to triannon/annotations#show with params' do
      expect(:get => "/annotations/iiif/666").to route_to(controller: "triannon/annotations", action: "show", anno_root: "iiif", id: '666')
    end
  end

  it "get /annotations/(root) routes to triannon/annotations/#index with anno_root param" do
    expect(:get => "/annotations/foo").to route_to(controller: "triannon/annotations", action: "index", anno_root: "foo")
  end

  context "create action" do
    it "post to /annotations/(root) routes to triannon/annotations#create with anno_root param" do
      expect(:post => "/annotations/foo").to route_to(controller: "triannon/annotations", action: "create", anno_root: "foo")
    end
    it "post to /annotations not routable" do
      expect(:post => "/annotations").not_to be_routable
    end
  end

  context "new action" do
    it "get /annotations/(root)/new routes to triannon/annotations#new with anno_root param" do
      expect(:get => "/annotations/foo/new").to route_to(controller: "triannon/annotations", action: "new", anno_root: "foo")
    end
    it "get to /annotations/new not routable" do
      expect(:get => "/annotations/new").not_to be_routable
    end
  end

  context "destroy action" do
    it "delete /annotations/(root)/:id routes to triannon/annotations#destroy with params" do
      expect(:delete => "/annotations/foo/1").to route_to("triannon/annotations#destroy", id: "1", anno_root: "foo")
    end
    it "delete to /annotations not routable" do
      expect(:delete => "/annotations").not_to be_routable
    end
  end

  # TODO:  PUT not yet implemented
  it "put annotations/(:id) does NOT route to triannon/annotations/#update" do
    expect(:put => "/annotations/1").not_to route_to("triannon/annotations#update", :id => "1")
    expect(:put => "/annotations/1").not_to be_routable
  end

end
