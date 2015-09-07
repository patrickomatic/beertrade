require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/users").to route_to("users#index")
    end

    it "routes to #show" do
      expect(get: "/users/patrickomatic").to route_to("users#show", id: "patrickomatic")
    end
  end
end
