module Api
    class ReviewsController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_request
  
      def create
        product = Product.find_by(id: review_params[:product_id])
        user = @current_user

        if product.nil?
          render json: { errors: ['Product does not exist'] }, status: :unprocessable_entity
          return
        end

        review = Review.new(review_params.merge(user_id: user.id))
        if review.save
          render json: { message: 'Review added successfully' }, status: :created
        else
          render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def index
        product = Product.find_by(id: params[:product_id])

        if product.nil?
          render json: { errors: ['Product does not exit'] }, status: :not_found
          return
        end

        reviews = Review.where(product_id: params[:product_id])
        render json: reviews.as_json(only: [:id, :product_id, :rating, :comment, :user_id]), status: :ok
      end

      private
  
      def review_params
        params.permit(:product_id, :rating, :comment)
      end
  
      def authenticate_request
        token = request.headers['Authorization'].split(' ').last
        decoded_token = JsonWebToken.decode(token)
        @current_user = User.find(decoded_token[:user_id])
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError
        render json: { errors: 'Invalid token' }, status: :unauthorized
      end
    end
  end
  