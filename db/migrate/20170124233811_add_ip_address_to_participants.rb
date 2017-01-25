class AddIpAddressToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :ip_address, :text
  end
end
