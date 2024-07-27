module Api
    module Admin
      class AnalyticsController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
  
        def sales
          start_date = params[:startDate].to_date
          end_date = params[:endDate].to_date
          
          orders = Order.where(status: 'sold', created_at: start_date.beginning_of_day..end_date.end_of_day)
          order_items = OrderItem.where(order: orders)

          product_sales = order_items.group_by(&:product_id).map do |product_id, items|
            product = Product.find(product_id)
            total_quantity = items.sum(&:quantity)

            {
              id: product.id,
              name: product.name,
              description: product.description,
              price: product.price,
              imgUrl: product.imgurl,
              salesAmount: total_quantity, 
              category: product.category.name 
            }
          end
          
          render json: product_sales, status: :ok        
        end
      end
    end
end