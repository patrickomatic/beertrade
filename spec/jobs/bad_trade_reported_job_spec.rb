require 'rails_helper'

RSpec.describe BadTradeReportedJob, type: :job do
  let(:job) { BadTradeReportedJob.new }

  describe "#perform" do
    let(:participant) { FactoryGirl.create(:participant) }

    it "should call notification.send_invites" do
      expect(Reddit).to receive(:pm)
      job.perform(participant.id)
    end
  end
end
