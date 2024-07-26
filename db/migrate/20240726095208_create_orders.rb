class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.decimal :total_amount
      t.string :payment_method

      t.timestamps
    end
  end
end
