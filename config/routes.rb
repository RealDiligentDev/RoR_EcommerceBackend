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

      # Product management routes 
      post 'admin/products', to: 'admin/products#create'
      get 'admin/products', to: 'admin/products#index'
      put 'admin/products/:id', to: 'admin/products#update'
      delete 'admin/products/:id', to: 'admin/products#destroy'

      #Order route
      post 'orders', to: 'orders#create'
  end
end
