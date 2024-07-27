module Api
    class CategoriesController < ApplicationController
        protect_from_forgery with: :null_session

        def index
            categories = Category.all 
            render json: categories.as_json(only: [:id, :name, :description]), status: :ok
        end
    end
end
