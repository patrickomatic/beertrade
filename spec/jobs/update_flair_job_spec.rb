require 'rails_helper'

RSpec.describe UpdateFlairJob, type: :job do
  let(:job) { UpdateFlairJob.new }

  describe "#perform" do
    let(:user) { FactoryGirl.create(:user) }
    
    it "should call User#update_flair" do
      expect(User).to receive(:find).with(user.id).and_return(user)
      expect(user).to receive(:update_flair).and_return(true)

      job.perform(user.id)
    end
  end
end
