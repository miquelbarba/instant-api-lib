class A < ActiveRecord::Migration
  def change
    create_table :as do |t|
      t.string :value

      t.timestamps
    end
  end
end
