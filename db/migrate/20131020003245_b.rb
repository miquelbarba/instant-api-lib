class B < ActiveRecord::Migration
  def change
    create_table :bs do |t|
      t.string :value
      t.integer :a_id

      t.timestamps
    end
  end
end
