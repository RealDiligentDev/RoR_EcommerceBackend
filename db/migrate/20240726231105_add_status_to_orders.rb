class AddStatusToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :status, :string, default: 'start'
  end
end
