require 'rails_helper'

RSpec.describe User, type: :model do
  let(:positive_feedback) { 20 } 
  let(:neutral_feedback)  { 0  } 
  let(:negative_feedback) { 0  } 
  let(:user) { FactoryGirl.build(:user, 
                                 positive_feedback: positive_feedback, 
                                 neutral_feedback:  neutral_feedback, 
                                 negative_feedback: negative_feedback) }


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


  describe "#check_if_moderator" do
    pending
  end


  describe "#to_param" do
    subject { user.to_param }

    it { is_expected.to eq("patrickomatic") }
  end


  describe "#update_reputation" do
    context "with valid feedback_type" do
      before { user.update_reputation(feedback_type) }

      context "with positive feedback" do
        let(:feedback_type) { :positive }

        it "should just update positive feedback" do
          expect(user.positive_feedback).to eq (positive_feedback + 1) 
          expect(user.neutral_feedback).to eq neutral_feedback
          expect(user.negative_feedback).to eq negative_feedback
        end
      end

      context "with neutral feedback" do
        let(:feedback_type) { :neutral }

        it "should just update positive feedback" do
          expect(user.positive_feedback).to eq positive_feedback 
          expect(user.neutral_feedback).to eq (neutral_feedback + 1)
          expect(user.negative_feedback).to eq negative_feedback
        end
      end

      context "with negative feedback" do
        let(:feedback_type) { :negative }

        it "should just update negative feedback" do
          expect(user.positive_feedback).to eq positive_feedback 
          expect(user.neutral_feedback).to eq neutral_feedback
          expect(user.negative_feedback).to eq (negative_feedback + 1)
        end
      end
    end


    context "with invalid feedback_type" do
      it "should raise an exception" do
        expect { user.update_feedback("invalid") }.to raise_error(String)
      end
    end
  end


  describe "#flair_css_class" do
    let(:positive_feedback) { 0 }
    subject { user.flair_css_class }


    it { is_expected.to be_nil }

    [
      ["between 1 and 5",    3,   "repLevel1"], 
      ["exactly 1",          1,   "repLevel1"], 
      ["between 5 and 10",   6,   "repLevel2"],
      ["exactly 5",          5,   "repLevel2"],
      ["between 10 and 40",  35,  "repLevel3"],
      ["exactly 10",         10,  "repLevel3"],
      ["between 40 and 100", 75,  "repLevel4"],
      ["exactly 40",         40,  "repLevel4"],
      ["over 100",           120, "repLevel5"],
      ["exactly 100",        100, "repLevel5"],
    ].each do |description, value, css_class|
      context description do
        let(:positive_feedback) { value }
        it { is_expected.to eq css_class }
      end
    end
  end


  describe "#update_flair" do
    let(:user) { FactoryGirl.create(:user, positive_feedback: 1) }

    it "should call Reddit.set_flair" do
      expect(Reddit).to receive(:set_flair).with(user.username, "100% positive", "repLevel1")
      user.update_flair
    end

    context "with no reputation" do
      let(:user) { FactoryGirl.create(:user) }

      it "should not call Reddit.set_flair" do
        expect(Reddit).not_to receive(:set_flair)
        user.update_flair
      end
    end
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
    subject { user.total_completed_trades }


    context "with no completed trades" do
      it { is_expected.to eq 0 }
    end

    context "with a participant with feedback" do
      before { FactoryGirl.create(:participant, :with_feedback, user: user) }

      it { is_expected.to eq 1 }
    end

    context "with a participant without feedback" do
      before { FactoryGirl.create(:participant, :accepted, user: user) }

      it { is_expected.to eq 0 }
    end
  end
end
