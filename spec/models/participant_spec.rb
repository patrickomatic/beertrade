require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:trade) { FactoryGirl.build(:trade, :accepted) }
  let(:participant) { trade.participants.first }


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
