class AddTotalAmountToOrderItems < ActiveRecord::Migration[7.2]
  def change
    add_column :order_items, :total_amount, :decimal
  end
end
