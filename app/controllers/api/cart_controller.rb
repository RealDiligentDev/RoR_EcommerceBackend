module Api
    class CartController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token, only: [:create, :destroy, :index]

        def create
            user = authenticate_request
            return unless user

            product = Product.find_by(id: cart_params[:productId])
            unless product
                render json: { errors: 'Product not found' }, status: :not_found
                return
            end

            cart_item = Cart.find_by(user: user, product: product)
            if cart_item
                cart_item.update(quantity: cart_params[:quantity])
            else
                Cart.create(user: user, product: product, quantity: cart_params[:quantity])
            end

            render json: { message: 'Product added to cart' }, status: :ok
        end

        def index
            user = authenticate_request
            return unless user

            cart_items = Cart.where(user: user).includes(:product)
            render json: cart_items.as_json(only: [:product_id, :quantity]), status: :ok
        end

        def destroy
            user = authenticate_request
            return unless user

            product = Product.find_by(id: params[:productId])
            unless product
                render json: { errors: 'Product not found' }, status: :not_found
                return
            end

            cart_item = Cart.find_by(user: user, product: product)
            if cart_item
                cart_item.destroy
                render json: { message: 'Product removed from cart' }, status: :ok
            else
                render json: { errors: 'Product not found in cart' }, status: :not_found
            end
        end   

        private

        def cart_params
            params.permit(:productId, :quantity)
        end

        def authenticate_request
            token = request.headers['Authorization']&.split(' ')&.last
            user_id = JsonWebToken.decode(token)[:user_id] if token
            User.find_by(id: user_id) if user_id
        rescue
            render json: { errors: 'Unauthorized' }, status: :unauthorized
        end
    end
end
