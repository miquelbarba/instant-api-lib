class Ad < ActiveRecord::Migration
  def change
    create_table :as_ds do |t|
      t.belongs_to :a
      t.belongs_to :d
    end
  end
end
