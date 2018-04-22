class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      #用户的地址可以被修改，但是用户的地址被添加到订单之后成为订单地址，则不能被修改
      t.string :address_type
      t.string :contact_name, :cellphone, :address, :zipcode
      t.timestamps
    end
    
    add_index :addresses, [:user_id, :address_type]
  end
end
