class D < ActiveRecord::Migration
  def change
    create_table :ds do |t|
      t.string :value

      t.timestamps
    end
  end
end
