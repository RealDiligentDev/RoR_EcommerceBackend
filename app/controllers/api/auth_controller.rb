module Api
  class AuthController < ApplicationController
    protect_from_forgery with: :null_session
    
    def register
      user = User.new(user_params)
      if user.save
        render json: { message: 'User registered successfully' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { user: user.id, token: token }, status: :ok
      else
        render json: { errors: 'Invalid email or password' }, status: :unauthorized
      end
    end

    def logout
      if request.headers['Authorization'].present?
        token = request.headers['Authorization'].split(' ').last
        BlacklistedToken.create(token: token) # Blacklist the token
        render json: { message: 'User logged out successfully' }, status: :ok
      else
        render json: { errors: 'No token provided' }, status: :unauthorized
      end
    end

    def recovery_key
      user = User.find_by(email: params[:email])
      if user
        recovery_key = generate_recovery_key(user)
        render json: { recoveryKey: recovery_key }, status: :ok
      else
        render json: { errors: 'User not found' }, status: :not_found
      end
    end

    def forget_password
      user = User.find_by(email: params[:email])

      if user && valid_recovery_key?(user, params[:recoveryKey])
        if user.update(password: params[:newPassword])
          RecoveryKey.find_by(user: user, key: params[:recoveryKey]).destroy
          render json: { message: 'Password updated successfully' }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end

      else
        render json: { errors: 'Invalid email or recovery key' }, status: :unprocessable_entity
      end
    end

    private

    def generate_recovery_key(user)
      key = SecureRandom.hex(16)
      RecoveryKey.create(user: user, key: key)
      key
    end

    def valid_recovery_key?(user, recovery_key)
      RecoveryKey.exists?(user: user, key: recovery_key)
    end

    def user_params
      params.permit(:username, :email, :password, :role)
    end
  end
end
