require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "#create_hash" do
    subject { FactoryGirl.build(:notification, hashcode: nil) }


    it { is_expected.to be_valid }

    it "should set #hashcode" do
      subject.save
      expect(subject.hashcode).not_to be_nil
    end

    context "with an existing #hashcode" do
      let!(:notification) { subject.clone }

      it "should not be valid" do
        subject.save
        expect(notification).not_to be_valid
      end
    end
  end


  describe "#seen?" do
    let(:notification) { FactoryGirl.build(:notification) }

    subject { notification.seen? }


    it { is_expected.to be false }

    context "with seen_at set" do
      let(:notification) { FactoryGirl.build(:notification, seen_at: Time.now) }
      it { is_expected.to be true }
    end
  end


  # TODO use a shared example to test all the reddit api calls
  describe ".updated_shipping" do
    before { expect(Reddit).to receive(:pm) }

    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }

    def update_shipping 
      Notification.updated_shipping(participant) 
    end

    it "should create Notification objects" do
      expect { update_shipping }.to change { Notification.count }.by 1
    end

    it "should have sent a PM" do
      pending
      update_shipping
      expect(Reddit).to have_received(:pm)
    end

    context "when called multiple times" do
      let(:multiple_update_shipping) { 5.times { update_shipping } }

      it "should create Notification objects" do
        expect { multiple_update_shipping }.to change { Notification.count }.by 1
      end

      it "should have sent a PM" do
        pending
        multiple_update_shipping
        expect(Reddit).to have_received(:pm)
      end
    end
  end


  describe ".send_invites" do
    before { expect(Reddit).to receive(:pm) }

    let(:participant) { FactoryGirl.create(:participant) }

    it "should create Notification objects" do
      expect { Notification.send_invites([participant]) }.to change { Notification.count }.by 1
    end
  end

  
  describe ".left_feedback" do
    before { expect(Reddit).to receive(:pm) }

    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }

    it "should create Notification objects" do
      expect { Notification.left_feedback(participant) }.to change { Notification.count }.by 1
    end
  end


  describe ".accepted_trade" do
    before { expect(Reddit).to receive(:pm) }

    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }

    it "should create Notification objects" do
      expect { Notification.accepted_trade(participant) }.to change { Notification.count }.by 1
    end
  end
end
