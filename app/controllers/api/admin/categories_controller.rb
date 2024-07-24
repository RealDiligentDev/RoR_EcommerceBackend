module Api
    module Admin 
        class CategoriesController < ApplicationController
            protect_from_forgery with: :null_session

            def create
                category = Category.new(category_params)
                if category.save
                    render json: { message: 'Category created successfully' }, status: :created
                else
                    render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
                end
            end

            def index
                categories = Category.all 
                render json: categories, status: :ok
            end

            def update
                category = Category.find(params[:id])
                if category.update(category_params)
                    render json: { message: 'Category updated successfully' }, status: :ok
                else
                    render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
                end
            end

            def destroy
                category = Category.find(params[:id])
                if category.destroy
                    render json: { message: 'Category deleted succssfully' }, status: :ok
                else
                    render json: { errors: 'Failed to delete category' }, status: :unprocessable_entity
                end
            end

            private
            
            def category_params
                params.permit(:name, :description)
            end            
        end        
    end
end


