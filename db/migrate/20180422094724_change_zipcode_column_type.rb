class ChangeZipcodeColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :zipcode, :integer
  end
end
