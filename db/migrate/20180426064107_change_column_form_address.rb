class ChangeColumnFormAddress < ActiveRecord::Migration[5.2]
  def change
    change_column :addresses, :cellphone, :decimal, precision: 11, scale: 0
  end
end
