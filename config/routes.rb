Rails.application.routes.draw do
  namespace :api do
      
      # Auth routes
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      get 'auth/logout', to: 'auth#logout'
      get 'auth/recoverykey', to: 'auth#recovery_key'
      post 'auth/forgetPassword', to: 'auth#forget_password'

      # Category management routes 
      post 'admin/categories', to: 'admin/categories#create'
      get 'admin/categories', to: 'admin/categories#index'
      put 'admin/categories/:id', to: 'admin/categories#update'
      delete 'admin/categories/:id', to: 'admin/categories#destroy'

  end
end
