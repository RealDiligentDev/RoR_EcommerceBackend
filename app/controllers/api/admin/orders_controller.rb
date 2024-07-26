module Api
    module Admin
      class OrdersController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
  
        def update_status
          order = Order.find(params[:id])
          if order.update(status: params[:status])
            render json: { message: 'Order status updated successfully' }, status: :ok
          else
            render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def index
          orders = Order.all 
          order_list = orders.map do |order|
            {
                id: order.id,
                clientId: order.client_id,
                productList: order.order_items.map do |item|
                    {
                        productId: item.product_id,
                        quantity: item.quantity,
                        totalAmount: item.total_amount
                    }
                end,
                status: order.status
            }
        end

        render json: order_list, status: :ok
      end
    end
  end
end 