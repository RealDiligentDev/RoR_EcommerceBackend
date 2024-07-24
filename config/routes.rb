Rails.application.routes.draw do
  namespace :api do
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      get 'auth/logout', to: 'auth#logout'
      get 'auth/recoverykey', to: 'auth#recovery_key'
      post 'auth/forgetPassword', to: 'auth#forget_password'
  end
end
