require "rails_helper"

RSpec.describe ModeratorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/moderators/").to route_to("moderators#index")
    end
  end
end
