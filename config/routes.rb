Storage::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root to: 'document#contracts'
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'contracts' => 'document#contracts', :as => :contracts
  match 'contracts/:id' => 'document#show_contract', :as => :contract
  
  match 'archives' => 'document#archives', :as => :archives
  match 'archives/:id' => 'document#show_archive', :as => :archive
  
  match 'standard/:id' => 'document#show_standard', :as => :show_standard
  match 'standards' => 'document#standards', :as => :standards
  
  match 'contracts/contracts_tree/:id' => 'document#contracts_tree', :as => :contracts_tree
  match 'archives/archives_tree/:id' => 'document#archives_tree', :as => :archives_tree
  
  match 'login' => 'sessions#login', :as => :login, :via => :post
  match 'logout' => 'sessions#logout', :as => :logout, :via => :delete
  
  match 'filter' => 'document#filter', :as => :filter
  match 'search' => 'document#search', :as => :search
  
  match 'file/:fold/show/:id' => 'file#show'
  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
