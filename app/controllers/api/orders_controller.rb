module Api
  class OrdersController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token
    before_action :authenticate_request

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
        order = Order.new(client_id: @current_user.id, payment_method: payment_method, status: 'start')

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

    def show
      order = Order.find_by(id: params[:id])

      if order
        order_details = {
          id: order.id,
          clientId: order.client_id,
          productListL: order.order_items.map do |item|
            {
              productId: item.product_id,
              quantity: item.quantity,
              totalAmount: item.total_amount
            }
          end,
          status:order.status
        }

        render json: order_details, status: :ok
      else
        render json: { errors: 'Order not found' }, status: :not_found
      end
    end

    private
    
    def authenticate_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      decoded = JsonWebToken.decode(header)
      if decoded
        @current_user = User.find(decoded[:user_id])
      else
        render json: { errors: 'Invalid or missing token' }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end