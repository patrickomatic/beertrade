require 'moderator_tools'
require 'rails_helper'

RSpec.describe UsernameChangeJob, type: :job do
  let(:job) { UsernameChangeJob.new }

  describe "#perform" do
    let(:user) { FactoryGirl.create(:user) }
    let(:new_user) { FactoryGirl.create(:user) }

    it "should call ModeratorTools.merge_trades_from_user" do
      expect(ModeratorTools).to receive(:merge_trades_from_user)
      job.perform(user.id, new_user.id)
    end
  end
end
