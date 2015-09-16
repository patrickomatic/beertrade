require 'rails_helper'

RSpec.describe TradeInviteJob, type: :job do
  let(:job) { TradeInviteJob.new }

  describe "#perform" do
    let(:participant) { FactoryGirl.create(:participant) }

    it "should call Notification.send_invites" do
      expect(Notification).to receive(:send_invites).with([participant])
      job.perform(participant.id)
    end
  end
end
