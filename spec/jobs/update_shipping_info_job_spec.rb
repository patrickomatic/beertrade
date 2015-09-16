require 'rails_helper'

RSpec.describe UpdateShippingInfoJob, type: :job do
  let(:job) { UpdateShippingInfoJob.new }

  describe "#perform" do
    let(:participant) { FactoryGirl.create(:participant) }
    
    it "should call Notification.updated_shipping" do
      expect(Notification).to receive(:updated_shipping).with(participant)
      job.perform(participant.id)
    end
  end
end
