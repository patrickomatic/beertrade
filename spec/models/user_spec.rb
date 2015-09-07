require 'rails_helper'

RSpec.describe User, type: :model do
  let(:positive_feedback) { 20 } 
  let(:negative_feedback) { 0 } 
  let(:neutral_feedback) { 0 } 
  let(:user) { FactoryGirl.build(:user, positive_feedback: positive_feedback, neutral_feedback: neutral_feedback, negative_feedback: negative_feedback) }


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


  describe "#to_param" do
    subject { user.to_param }

    it { is_expected.to eq("patrickomatic") }
  end


  describe "#reputation" do
    subject { user.reputation }


    it { is_expected.to eq 100 }

    context "with netural feedback" do
      let(:netural_feedback) { 2 }

      it { is_expected.to eq 100 }
    end

    context "with negative feedback" do
      let(:negative_feedback) { 2 }

      it { is_expected.to eq 91 }
    end

    context "with mixed feedback" do
      let(:positive_feedback) { 8 }
      let(:negative_feedback) { 1 }
      let(:neutral_feedback) { 1 }

      it { is_expected.to eq 89 }
    end
  end


  describe "#total_completed_trades" do
    pending
  end
end
