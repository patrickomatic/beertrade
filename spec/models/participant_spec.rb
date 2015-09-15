require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:trade) { FactoryGirl.build(:trade, :accepted) }
  let(:participant) { trade.participants.first }


  describe "validations" do
    subject { participant }


    it { is_expected.to be_valid }

    context "with partial feedback" do
      before { participant.feedback = "some feedback" }
      it { is_expected.not_to be_valid }
    end

    context "with full feedback" do
      before do 
        participant.feedback = "some feedback" 
        participant.feedback_type = :positive
      end

      it { is_expected.to be_valid }
    end

    context "with negative feedback" do
      before do 
        participant.feedback = "some feedback" 
        participant.feedback_type = :negative
      end

      it { is_expected.to be_valid }
    end
  end


  describe "#other_participant" do
    subject { participant.other_participant }
    it { is_expected.to be trade.participants.second }
  end

  describe "#other_participants" do
    subject { participant.other_participants }
    it { is_expected.to eq [trade.participants.second] }
  end


  describe "#send_invite" do
    pending
  end
end
