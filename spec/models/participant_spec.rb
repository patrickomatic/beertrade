require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:trade) { FactoryGirl.build(:trade, :accepted) }
  let(:participant) { trade.participants.first }


  describe "validations" do
    subject { participant }


    it { is_expected.to be_valid }

    context "with just feedback_type" do
      before { participant.feedback_type = :negative }
      it { is_expected.not_to be_valid }
    end

    context "with just feedback" do
      before { participant.feedback = "some feedback" }
      it { is_expected.not_to be_valid }
    end

    context "with blank feedback" do
      before do 
        participant.feedback = "" 
        participant.feedback_type = :positive
      end

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


    it "should update completed_at" do
      participant.other_participant.update_attributes(feedback: "ok trader", feedback_type: :neutral)

      expect { participant.save }.to change { participant.trade.completed_at }
    end
  end
end
