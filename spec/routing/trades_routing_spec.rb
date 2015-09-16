require "rails_helper"

RSpec.describe TradesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/trades").to route_to("trades#index")
    end

    it "routes to #new" do
      expect(get: "/trades/new").to route_to("trades#new")
    end

    it "routes to #show" do
      expect(get: "/trades/1").to route_to("trades#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/trades").to route_to("trades#create")
    end

    it "routes to #destroy" do
      expect(delete: "/trades/1").to route_to("trades#destroy", id: "1")
    end
  end
end
