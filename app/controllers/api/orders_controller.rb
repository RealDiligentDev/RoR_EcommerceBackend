module Api
  class OrdersController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    def create
      # Extract parameters
      product_list = params[:productList]
      payment_method = params[:paymentMethod]

      # Basic validation
      if product_list.blank? || payment_method.blank?
        render json: { errors: 'Missing required parameters' }, status: :unprocessable_entity
        return
      end

      # Ensure all products exist and quantities are valid
      valid_products = product_list.all? do |item|
        product = Product.find_by(id: item[:productId])
        product.present? && product.quantity >= item[:quantity].to_i
      end

      if valid_products
        # Create the order
        order = Order.new(payment_method: payment_method)

        if order.save
          total_amount_calculated = 0.0

          product_list.each do |item|
            product = Product.find_by(id: item[:productId])
            total_amount_calculated += item[:totalAmount].to_f
            OrderItem.create(order: order, product: product, quantity: item[:quantity].to_i, total_amount: item[:totalAmount].to_f)
            product.update(quantity: product.quantity - item[:quantity].to_i)
          end

          # Send a success response
          render json: { message: 'Order placed successfully' }, status: :created
        else
          render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: 'Invalid product details' }, status: :unprocessable_entity
      end
    end
  end
end
