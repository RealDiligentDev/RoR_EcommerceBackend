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
    get 'categories', to: 'categories#index'

    # Product management routes 
    post 'admin/products', to: 'admin/products#create'
    get 'admin/products', to: 'admin/products#index'
    put 'admin/products/:id', to: 'admin/products#update'
    delete 'admin/products/:id', to: 'admin/products#destroy'

    # Admin Analytics routes
    get 'admin/analytics/sales', to: 'admin/analytics#sales'

    # Order route
    post 'orders', to: 'orders#create'
    get 'orders/:id', to: 'orders#show'
    put 'admin/orders/:id/status', to: 'admin/orders#update_status'
    get 'admin/orders', to: 'admin/orders#index'

    # Profile route
    get 'profile', to: 'profile#show'
    put 'profile', to: 'profile#update'

    # Review routes
    post 'reviews', to: 'reviews#create'
    get 'reviews/:product_id', to: 'reviews#index'

    # Product browsing routes
    get 'products', to: 'products#index'
    get 'products/:id', to: 'products#show'

    # Cart routes
    post 'cart', to: 'cart#create'
    get 'cart', to: 'cart#index'
    delete 'cart/:productId', to: 'cart#destroy'
  end
end
