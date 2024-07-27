module Api
    class ProfileController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_request
      
      def show
        user = @current_user
        render json: {
            id: user.id,
            username: user.username,
            email: user.email,
            role: user.role
        }, status: :ok
      end
 
      def update
        user = @current_user
        if user.update(user_params)
            render json: { message: 'Pofile updated successfully' }, status: :ok
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
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

      def user_params
        params.permit(:username, :email, :password)
      end
    end
  end