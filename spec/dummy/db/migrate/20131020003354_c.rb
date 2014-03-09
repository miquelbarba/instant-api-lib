class C < ActiveRecord::Migration
  def change
    create_table :cs do |t|
      t.string :value
      t.integer :b_id
      t.integer :a_id

      t.timestamps
    end
  end
end
