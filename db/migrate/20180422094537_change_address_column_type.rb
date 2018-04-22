class ChangeAddressColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :address, :text
  end
end
