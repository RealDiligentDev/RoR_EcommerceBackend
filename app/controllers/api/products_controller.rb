module Api
    class ProductsController < ApplicationController
      protect_from_forgery with: :null_session
  
      def index
        # Fetch query parameters
        page = params[:page] || 1
        limit = params[:limit] || 10
        category_name = params[:category]
  
        # Query products
        products = Product.all
        products = products.joins(:category).where(categories: { name: category_name }) if category_name.present?
        products = products.page(page).per(limit)
  
        # Respond with JSON
        render json: products.as_json(only: [:id, :name, :description, :price, :category_id]), status: :ok
      end

      def show
        product = Product.find_by(id: params[:id])

        if product
            render json: product.as_json(only: [:id, :name, :description, :price, :category_id]), status: :ok
        else
            render json: { errors: 'Product not found' }, status: :not_found
        end
      end
    end
  end
  