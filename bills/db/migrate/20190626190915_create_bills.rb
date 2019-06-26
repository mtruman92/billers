class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|

      t.timestamps null: false
    end
  end
end
