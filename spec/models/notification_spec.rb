require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "#seen?" do
    let(:notification) { FactoryGirl.build(:notification) }

    subject { notification.seen? }


    it { is_expected.to be false }

    context "with seen_at set" do
      let(:notification) { FactoryGirl.build(:notification, seen_at: Time.now) }
      it { is_expected.to be true }
    end
  end


  describe "::updated_shipping" do
    before { expect(Notification).to receive(:reddit_pm) }

    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }

    it "should create Notification objects" do
      expect { Notification.updated_shipping(participant) }.to change { Notification.count }.by 1
    end
  end


  describe "::send_invites" do
    before { expect(Notification).to receive(:reddit_pm) }

    let(:participant) { FactoryGirl.create(:participant) }

    it "should create Notification objects" do
      expect { Notification.send_invites([participant]) }.to change { Notification.count }.by 1
    end
  end

  
  describe "::left_feedback" do
    before { expect(Notification).to receive(:reddit_pm) }

    let(:participant) { FactoryGirl.create(:participant) }

    it "should create Notification objects" do
      expect { Notification.left_feedback(participant) }.to change { Notification.count }.by 1
    end
  end
end
