require 'rails_helper'

RSpec.describe AcceptedTradeJob, type: :job do
  let(:job) { AcceptedTradeJob.new }

  describe "#perform" do
    let(:trade) { FactoryGirl.create(:trade, :waiting_for_approval) }

    it "should call Notification.accepted_trade" do
      expect(Reddit).to receive(:pm)
      job.perform(trade.participants.first.id)
    end
  end
end
