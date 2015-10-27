require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  describe ".find_by_username" do
    let(:username) { "patrickomatic" }
    before { user.save! }

    subject { User.find_by_username(username) }

    it { is_expected.to eq(user) }

    context "with mixed case" do
      let(:username) { "pAtrickOMATIC" }
      it { is_expected.to eq(user) }
    end
  end


  describe "#to_s" do
    subject { user.to_s }

    it { is_expected.to eq("/u/patrickomatic") }
  end


  describe "#check_if_moderator" do
    pending
  end


  describe "#to_param" do
    subject { user.to_param }

    it { is_expected.to eq("patrickomatic") }
  end


  describe "#flair_css_class" do
    let(:trade_count) { 0 }
    let(:user) { FactoryGirl.create(:user, :with_trades, positive_trade_count: trade_count) }
    subject { user.flair_css_class }


    it { is_expected.to be_nil }

    [
      ["between 1 and 5",    3,   "repLevel1"], 
      ["exactly 1",          1,   "repLevel1"], 
      ["between 5 and 10",   6,   "repLevel2"],
      ["exactly 5",          5,   "repLevel2"],
      ["between 10 and 40",  35,  "repLevel3"],
      ["exactly 10",         10,  "repLevel3"],
      ["between 40 and 100", 75,  "repLevel4"],
      ["exactly 40",         40,  "repLevel4"],
      ["over 100",           120, "repLevel5"],
      ["exactly 100",        100, "repLevel5"],
    ].each do |description, value, css_class|
      context description do
        let(:trade_count) { value }
        it { is_expected.to eq css_class }
      end
    end
  end


  describe "#update_flair" do
    let(:user) { FactoryGirl.create(:user, :with_trades) }

    it "should call Reddit.set_flair" do
      expect(Reddit).to receive(:set_flair).with(user.username, "100% positive", "repLevel1") 
      user.update_flair
    end

    context "with no reputation" do
      let(:user) { FactoryGirl.create(:user) }

      it "should not call Reddit.set_flair" do
        expect(Reddit).not_to receive(:set_flair)
        user.update_flair
      end
    end
  end


  describe "#reputation" do
    let(:user) { FactoryGirl.create(:user, :with_trades) }
    subject { user.reputation }


    it { is_expected.to eq 100 }

    context "with netural feedback" do
      let(:user) { FactoryGirl.create(:user, :with_trades, neutral_trade_count: 2) }

      it { is_expected.to eq 100 }
    end

    context "with negative feedback" do
      let(:user) { FactoryGirl.create(:user, :with_trades, positive_trade_count: 20, negative_trade_count: 2) }

      it { is_expected.to eq 91 }
    end

    context "with mixed feedback" do
      let(:user) { FactoryGirl.create(:user, :with_trades, positive_trade_count: 8, negative_trade_count: 1, neutral_trade_count: 1) }

      it { is_expected.to eq 89 }
    end
  end


  describe "#total_completed_trades" do
    subject { user.total_completed_trades }


    context "with no completed trades" do
      it { is_expected.to eq 0 }
    end

    context "with a participant with feedback" do
      before { FactoryGirl.create(:participant, :with_feedback, user: user) }

      it { is_expected.to eq 1 }
    end

    context "with a participant without feedback" do
      before { FactoryGirl.create(:participant, :accepted, user: user) }

      it { is_expected.to eq 0 }
    end
  end
end
