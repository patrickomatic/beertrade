require "rails_helper"

RSpec.describe ParticipantsController, type: :routing do
  describe "routing" do
    it "routes to #edit" do
      expect(get: "/trades/1/participants/1/edit").to route_to("participants#edit", trade_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/trades/1/participants/").to route_to("participants#create", trade_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/trades/1/participants/1").to route_to("participants#update", trade_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/trades/1/participants/1").to route_to("participants#update", trade_id: "1", id: "1")
    end
  end
end
