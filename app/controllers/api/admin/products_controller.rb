module Api
    module Admin
      class ProductsController < ApplicationController
        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
  
        def create
          category = Category.find_by(id: product_params[:categoryId])
          unless category
            render json: { errors: 'Category does not exist' }, status: :unprocessable_entity
            return
          end
  
          product = Product.new(product_params.except(:categoryId))
          product.category = category
          
          if product.save
            render json: { message: 'Product created successfully' }, status: :created
          else
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def index
          products = Product.all
          render json: products, status: :ok
        end
  
        def update
          product = Product.find_by(id: params[:id])
          unless product
            render json: { errors: 'Product not found' }, status: :not_found
            return
          end
  
          category = Category.find_by(id: product_params[:categoryId])
          unless category
            render json: { errors: 'Category does not exist' }, status: :unprocessable_entity
            return
          end
  
          if product.update(product_params.except(:categoryId))
            product.category = category
            product.save
            render json: { message: 'Product updated successfully' }, status: :ok
          else
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def destroy
          product = Product.find_by(id: params[:id])
          if product&.destroy
            render json: { message: 'Product deleted successfully' }, status: :ok
          else
            render json: { errors: 'Product not found or failed to delete' }, status: :unprocessable_entity
          end
        end
  
        private
  
        def product_params
          params.permit(:name, :description, :imgurl, :quantity, :price, :categoryId)
        end
      end
    end
  end
  