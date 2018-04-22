class AdddDefaultAddressIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :default_address_id, :integer
  end
end
