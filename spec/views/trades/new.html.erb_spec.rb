require 'rails_helper'

RSpec.describe "trades/new", type: :view do
  before(:each) do
    assign(:trade, FactoryGirl.create(:trade))
  end

  it "renders new trade form" do
    render

    assert_select "form[action=?][method=?]", trades_path, "post" do
    end
  end
end
