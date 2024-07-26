class RemoveTotalAmountFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :total_amount, :decimal
  end
end
