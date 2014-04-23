YoTePago::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

   resources :sessions, only: [:new, :create, :destroy]
   resources :users do
     member do
       get 'clientes'
       get 'new_cliente'
       post 'new_cliente' => "users#create_cliente"
     end
     resources :advertisings do
       member do
         get 'video'
         get 'encuesta'
         get 'new_encuesta'
         put 'new_encuesta' => "advertisings#update"
       end
     end
   end
   root :to=>'home#index'

   #Paginas estaticas
   get "contacto" => "static_pages#contacto"
   get "about" => "static_pages#about"
   get "help" => "static_pages#help"

   match '/signin',  to: 'sessions#new', via: 'get'
   match '/signout', to: 'sessions#destroy', via: 'delete'

   match '/signup',  to: 'users#new', via: 'get'
   match '/edit',  to: 'users#edit', via: 'get'

   #JS
   get "load_ciudades" => "users#load_ciudades"
   get "load_comunas" => "users#load_comunas"
   get "player" => "advertisings#player"

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
