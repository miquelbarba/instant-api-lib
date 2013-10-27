class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.integer :age
      t.date :born_at
      t.datetime :registered_at
      t.boolean :terms_accepted
      t.decimal :money, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
