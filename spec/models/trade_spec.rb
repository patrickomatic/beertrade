require 'rails_helper'

RSpec.describe Trade, type: :model do
  describe "#completed?" do
    let(:trade) { FactoryGirl.create(:trade, :completed) }

    subject { trade.completed? }

    it { is_expected.to be true }

    context "when waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
      it { is_expected.to be false }
    end
  end


  describe "#waiting_for_approval?" do
    let(:trade) { FactoryGirl.create(:trade, :completed) }
    let(:approver) { trade.participants.first }

    subject { trade.waiting_for_approval?(approver) }

    it { is_expected.to be false }

    context "when waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
      it { is_expected.to be true }
    end
  end


  describe "#waiting_for_feedback?" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:waiting_for) { trade.participants.first }

    subject { trade.waiting_for_feedback?(waiting_for) }

    it { is_expected.to be true }
  end


  describe "#can_delete?" do
    let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
    let(:pending_for) { trade.participants.first }

    subject { trade.can_delete?(pending_for) }

    it { is_expected.to be true }
  end


  describe "#create_participants" do
    let(:trade) { FactoryGirl.build(:trade) }
    let(:requester) { FactoryGirl.create(:user) }
    let(:requestee) { FactoryGirl.create(:user) }
    
    pending # XXX
  end


  describe "#to_s" do
    let(:agreement) { nil }
    let(:trade) { FactoryGirl.create(:trade, :accepted, agreement: agreement) }
    let(:user1) { trade.participants.first.user }
    let(:user2) { trade.participants.second.user }

    subject { trade.to_s }

    it { is_expected.to eq "#{user1.username} and #{user2.username}" }

    context "with an agreement" do 
      let(:agreement) { "yinlins and stuff" }
      it { is_expected.to eq "#{user1.username} and #{user2.username}: #{agreement}" }
    end
  end
end
