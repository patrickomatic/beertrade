require 'rails_helper'

RSpec.describe ParticipantsHelper, type: :helper do
  let(:supported_feedbacks) { ["positive", "negative", "neutral"] }


  describe "#feedback_text" do
    let(:feedback_type) { "positive" }
    let(:exclude_type) { nil }
    let(:content) { "great yinlin trade!!" }

    subject { helper.feedback_text(feedback_type, exclude_type) { content } }


    it { is_expected.to include "glyphicon-ok" }
    it { is_expected.to include "text-success" }

    context "when it matches the exclude_type" do
      let(:exclude_type) { "positive" }

      it { is_expected.to eq content }
      it { is_expected.not_to include "glyphicon-ok" }
      it { is_expected.not_to include "text-success" }
    end
  end


  describe "#class_for_feedback_text" do
    it "should not be nil for supported feedback types" do
      supported_feedbacks.each do |feedback|
        expect(helper.class_for_feedback_text(feedback)).not_to be_nil
      end
    end

    it "should be nil for non-supported feedback types" do
      expect(helper.class_for_feedback_text("asdf")).to be_nil
    end
  end


  describe "#glyphicon_for_feedback" do
    it "should not be nil for supported feedback types" do
      supported_feedbacks.each do |feedback|
        expect(helper.glyphicon_for_feedback(feedback)).not_to be_nil
      end
    end

    it "should be nil for non-supported feedback types" do
      expect(helper.glyphicon_for_feedback("asdf")).to be_nil
    end
  end


  describe "#trade_status_message" do
    subject { helper.trade_status_message(trade) }

    context "with a trade that's not yet accepted" do
      let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }

      it { is_expected.to be_html_safe }
      it { is_expected.to include("not yet accepted") }
    end

    context "with a trade that's pending feedback" do
      let(:trade) { FactoryGirl.create(:trade, :accepted) }

      it { is_expected.to be_html_safe }
      it { is_expected.to include("waiting for feedback") }
    end

    context "with a trade that's completed" do
      let(:trade) { FactoryGirl.create(:trade, :completed) }
      it { is_expected.to be_nil }
    end
  end
end
