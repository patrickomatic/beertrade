require 'rails_helper'

RSpec.describe "trades/show", type: :view do
  before(:each) do
    @trade = FactoryGirl.create(:trade)
  end

  it "renders attributes in <p>" do
    render
  end
end
