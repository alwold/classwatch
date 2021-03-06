Classwatch::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => "sessions", :registrations => "registrations" }

  resources :classes, :except => [ :new, :index, :show ] do
    post :pay, on: :collection
  end

  get "classes/create_from_session" => "classes#create_from_session", as: "create_class_from_session"

  get "classes/lookup/:institution_id/:term_id/:input_1" => "classes#lookup", as: "lookup_class"
  get "classes/lookup/:institution_id/:term_id/:input_1/:input_2" => "classes#lookup"
  get "classes/lookup/:institution_id/:term_id/:input_1/:input_2/:input_3" => "classes#lookup"

  post "user/create"

  post "user/login"

  get "user/logout"

  get "home/index"

  get "settings/index"

  put "settings/update"

  resources :terms do
    collection do
      get "get/:school_id" => "terms#get", as: "get"
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

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
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
