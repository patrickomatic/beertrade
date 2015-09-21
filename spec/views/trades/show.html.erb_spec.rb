require 'rails_helper'

RSpec.describe "trades/show", type: :view do
  before(:each) do
    #allow(view).to receive(:current_user).and_return(nil) XXX 
    @trade = FactoryGirl.create(:trade)
  end

  it "renders attributes in <p>" do
    pending
    render
  end
end
