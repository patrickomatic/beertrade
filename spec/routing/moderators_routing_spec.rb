require "rails_helper"

RSpec.describe ModeratorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/moderators/").to route_to("moderators#index")
    end

    it "routes to #import_trades" do
      expect(get: "/moderators/import_trades").to route_to("moderators#import_trades")
    end

    it "routes to #change_username" do
      expect(get: "/moderators/change_username").to route_to("moderators#change_username")
    end

    it "routes to #add_trade" do
      expect(get: "/moderators/add_trade").to route_to("moderators#add_trade")
    end
  end
end
