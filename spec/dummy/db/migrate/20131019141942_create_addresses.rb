class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :number
      t.string :postal_code
      t.string :city
      t.string :country
      t.integer :user_id

      t.timestamps
    end
  end
end
