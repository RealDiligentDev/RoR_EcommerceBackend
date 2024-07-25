module Api
    module Admin
        class ProductsController < ApplicationController
            protect_from_forgery with: :null_session

            def create
                product = Product.new(product_params)
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
                product = Product.find(params[:id])
                if product.update(product_params)
                    render json: { message: 'Product updated succssfully' }, status: :ok
                else 
                    render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
                end
            end

            def destroy
                product = Product.find(params[:id])
                if product.destroy
                    render json: { message: 'Product deleted succssfully' }, status: :ok
                else 
                    render json: { errors: 'Failed to delete product' }, status: :unprocessable_entity
                end
            end

            def product_params
                params.permit(:name, :description, :imgurl, :quantity, :price, :category_id)
            end
        end
    end
end