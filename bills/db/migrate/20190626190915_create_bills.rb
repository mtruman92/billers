class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :bill_name
      t.decimal :bill_amount
      t.date :due_date
      #t.boolean :auto_pay
      #t.text :category
      #t.boolean :repeat
      t.boolean :paid
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
