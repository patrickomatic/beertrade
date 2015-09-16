require 'rails_helper'

RSpec.describe UpdateFeedbackJob, type: :job do
  let(:job) { UpdateFeedbackJob.new }

  describe "#perform" do
    let(:participant) { FactoryGirl.create(:participant) }
    
    it "should call Notification.left_feedback" do
      expect(Notification).to receive(:left_feedback).with(participant)
      job.perform(participant.id)
    end
  end
end
