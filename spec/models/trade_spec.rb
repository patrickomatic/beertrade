require 'rails_helper'

RSpec.describe Trade, type: :model do
  describe '.basic_search' do
    subject { Trade.completed.basic_search(agreement: 'pliny') }

    context 'with a completed trade' do
      let(:matched_trade_1) { FactoryGirl.create(:trade, :completed, agreement: 'pliny for foo') }
      let(:matched_trade_2) { FactoryGirl.create(:trade, :completed, agreement: 'pliny for bar') }
      let(:unmatched_trade_1) { FactoryGirl.create(:trade, :completed, agreement: 'foo for bar') }

      it { is_expected.to match_array [matched_trade_1, matched_trade_2] }
    end

    context 'with an accepted trade' do
      let!(:matched_trade) { FactoryGirl.create(:trade, :accepted, agreement: 'pliny for foo') }

      it { is_expected.to be_empty }
    end

    context 'with a trade awaiting approval' do
      let!(:matched_trade) { FactoryGirl.create(:trade, :waiting_for_approval, agreement: 'pliny for foo') }

      it { is_expected.to be_empty }
    end
  end

  describe "#lowest_feedback" do
    let(:trade) { FactoryGirl.create(:trade, :completed) }
    subject { trade.lowest_feedback }


    it { is_expected.to eq "positive" }

    context "with bad feedback" do
      before { trade.participants.first.feedback_type = :negative }
      it { is_expected.to eq "negative" }
    end

    context "with an uncompleted trade" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
      it { is_expected.to be_nil }
    end
  end


  describe "#completed?" do
    let(:trade) { FactoryGirl.create(:trade, :completed) }
    subject { trade.completed? }


    it { is_expected.to be true }

    context "when waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
      it { is_expected.to be false }
    end
  end


  describe "#all_feedback_given?" do
    let(:trade) { FactoryGirl.create(:trade) }

    subject { trade.all_feedback_given? }


    it { is_expected.to be false }

    context "with an accepted trade" do
      let(:trade) { FactoryGirl.create(:trade, :accepted) }
      it { is_expected.to be false }
    end

    context "with a completed trade" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }
      it { is_expected.to be true }
    end
  end


  describe "#has_shipping_info?" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }

    subject { trade.has_shipping_info? }


    it { is_expected.to be false }

    context "with participants with shipping_info" do
      before { trade.participants << FactoryGirl.create(:participant, :with_shipping_info) }
      it { is_expected.to be true }
    end
  end


  describe "#participant" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:user) { FactoryGirl.create(:participant).user }

    subject { trade.participant(user) }


    it { is_expected.to be_nil }

    context "when user is nil" do
      let(:user) { nil }

      it { is_expected.to be_nil }
    end

    context "when participant exists" do
      let(:participant) { trade.participants.first }
      let(:user) { participant.user }

      it { is_expected.to eq participant }
    end
  end


  describe "#accepted?" do
    let(:trade) { FactoryGirl.create(:trade) }
    subject { trade.accepted? }


    it { is_expected.to be false }

    context "when completed" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }
      it { is_expected.to be true }
    end

    context "when accepted" do
      let(:trade) { FactoryGirl.create(:trade, :accepted) }
      it { is_expected.to be true }
    end

    context "when waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
      it { is_expected.to be false }
    end
  end


  describe "#waiting_for_approval?" do
    let(:trade) { FactoryGirl.create(:trade, :completed) }
    let(:approver) { trade.participants.first.user }

    subject { trade.waiting_for_approval?(approver) }


    it { is_expected.to be false }

    context "when waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
      it { is_expected.to be true }
    end
  end


  describe "#waiting_to_give_feedback?" do
    let(:trade) { FactoryGirl.create(:trade, :accepted) }
    let(:waiting_for) { trade.participants.first.user }

    subject { trade.waiting_to_give_feedback?(waiting_for) }


    it { is_expected.to be true }

    context "with feedback from one participant" do
      let(:participant1) { trade.participants.first }
      let(:participant2) { participant1.other_participant }

      before do
        participant1.update_attributes(feedback: "feedback", feedback_type: :positive)
      end


      it "should only be true for participant1" do
        expect(trade.waiting_to_give_feedback?(participant1.user)).to be true
        expect(trade.waiting_to_give_feedback?(participant2.user)).to be false
      end
    end
  end


  describe "#can_see?" do
    let(:user) { nil }

    subject { trade.can_see?(user) }

    context "with a completed trade" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }

      it { is_expected.to be true }

      context "with a logged in user" do
        let(:user) { FactoryGirl.create(:user) }

        it { is_expected.to be true }
      end

      context "with a logged in user that is a participant" do
        let(:user) { trade.participants.first.user }

        it { is_expected.to be true }
      end
    end

    context "with a trade waiting for approval" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }

      it { is_expected.to be_falsey }

      context "with a logged in user" do
        let(:user) { FactoryGirl.create(:user) }

        it { is_expected.to be false }
      end

      context "with a logged in user that is a participant" do
        let(:user) { trade.participants.first.user }

        it { is_expected.to be true }
      end
    end
  end


  describe "#can_delete?" do
    let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }
    let(:pending_for) { trade.participants.first.user }

    subject { trade.can_delete?(pending_for) }

    it { is_expected.to be true }

    context "with the user that created it" do
      let(:pending_for) { trade.participants.second.user }
      it { is_expected.to be false }
    end

    context "with a moderator" do
      let(:pending_for) { FactoryGirl.create(:user, moderator: true) }
      it { is_expected.to be true }
    end
  end


  describe "#create_participants" do
    let(:trade) { FactoryGirl.build(:trade) }
    let(:requester) { FactoryGirl.create(:user) }
    let(:requestee) { FactoryGirl.create(:user) }

    pending # XXX will need to stub api calls
  end


  describe "#to_s" do
    let(:agreement) { nil }
    let(:trade) { FactoryGirl.create(:trade, :accepted, agreement: agreement) }

    subject { trade.to_s }

    it { is_expected.to start_with("trade on ") }

    context "with an agreement" do
      let(:agreement) { "yinlins and stuff" }
      it { is_expected.to eq agreement }
    end
  end
end
