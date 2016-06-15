namespace :unaccepted_trades do
  desc "clear out trades which haven't been accepted by the other party and are a month old"
  task clear: :environment do
    Trade.joins(:participants).merge(Participant.old_and_not_yet_accepted).find_each &:destroy!
  end
end
