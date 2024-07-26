class AddClientIdToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :client_id, :integer
  end
end
