Rails.application.routes.draw do
  get 'sessions/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #scope "/:locale" do
  root 'static#home'
  
  match '/help',     to: 'static#help',     via: 'get'
  match '/about',    to: 'static#about',    via: 'get'
  match '/contact',  to: 'static#contact',  via: 'get'
  match '/info',  to: 'static#info',  via: 'get'
  
  match 'en',     to: 'static#english',  via: 'get'
  match 'sr',     to: 'static#srpski',  via: 'get'
  match 'es',     to: 'static#espanol',  via: 'get'
  
  #
  
  resources :users do
    resources :uploads
  end
  resources :users do
    resources :refresh
  end
  resources :users do
    resources :csv
  end
   resources :users do
    resources :ispravka
  end

  get '/bla' => 'uploads#unesi'
  get 'signup'  => 'users#new'
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  
  resources :companies do
    collection do 
      get 'search'
    end
  end
 
#end
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
