require 'rails_helper'

RSpec.describe CheckIfModeratorJob, type: :job do
  let(:job) { CheckIfModeratorJob.new }

  describe "#perform" do
    let(:user) { FactoryGirl.create(:user) }

    it "should call User#check_if_moderator" do
      expect(User).to receive(:find).with(user.id).and_return(user)
      expect(user).to receive(:check_if_moderator)

      job.perform(user.id)
    end
  end
end
