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

    context "with valid shipping_info" do
      before { participant.shipping_info = "774397776602" }
      it { is_expected.to be_valid }
    end

    context "with invalid shipping_info" do
      before { participant.shipping_info = "xxx" }
      it { is_expected.not_to be_valid }
    end
  end


  describe "#accepted?" do
    let(:participant) { FactoryGirl.build(:participant) }

    subject { participant.accepted? }


    it { is_expected.to be false }

    context "with accepted participant" do
      let(:participant) { FactoryGirl.create(:participant, :accepted) }
      it { is_expected.to be true }
    end

    context "with feedback for participant" do
      let(:participant) { FactoryGirl.create(:participant, :with_feedback) }
      it { is_expected.to be true }
    end
  end


  describe "#waiting_to_give_feedback?" do
    subject { participant.waiting_to_give_feedback? }


    it { is_expected.to be true }

    context "with accepted participant" do
      let(:trade) { FactoryGirl.create(:trade, :accepted) }

      it { is_expected.to be true }
    end

    context "with feedback for participant" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }

      it { is_expected.to be false }
    end

    context "with feedback for participant" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }
      before { participant.other_participant.feedback = nil }

      it { is_expected.to be true }
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


  describe "#update_feedback" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }
    let(:feedback_type) { :positive }

    before do
      participant.feedback = "Great trade" 
      participant.feedback_type = feedback_type
    end


    it "should update reputation" do
      expect { participant.save }.to change { participant.user.positive_feedback }.by 1
    end

    it "should trigger background jobs" do
      expect(UpdateFeedbackJob).to receive(:perform_later).with(participant.id)
      expect(UpdateFlairJob).to receive(:perform_later).with(participant.user.id)

      participant.save
    end

    it "should update completed_at" do
      participant.other_participant.update_attributes(feedback: "ok trader", feedback_type: :neutral)

      expect { participant.save }.to change { participant.trade.completed_at }
    end


    context "with negative feedback" do
      let(:feedback_type) { :negative }

      it "should trigger a bad trade report" do
        expect(BadTradeReportedJob).to receive(:perform_later).with(participant.id)
        participant.save
      end

      context "when approved by a moderator" do
        before { participant.moderator_approved_at = Time.now }

        it "should update reputation" do
          expect { participant.save }.to change { participant.user.negative_feedback }.by 1
        end

        it "should trigger background jobs" do
          expect(UpdateFeedbackJob).to receive(:perform_later).with(participant.id)
          expect(UpdateFlairJob).to receive(:perform_later).with(participant.user.id)

          participant.save
        end
      end
    end
  end


  describe "#update_shipping_info" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:participant) { trade.participants.first }

    before do
      participant.shipping_info = "774397776602"
    end

    it "should trigger background jobs" do
      expect(UpdateShippingInfoJob).to receive(:perform_later).with(participant.id)
      participant.save
    end
  end
end
