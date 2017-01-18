Rails.application.routes.draw do

  # devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  devise_for :users, :controllers => { omniauth_callbacks: "omniauth_callbacks", sessions: "sessions", registrations: "registrations" }

  root to: "home#index"
  resources :cases do
    member do
      get 'allocate_funds'
      post 'confirm_funds_allocation'
      post 'approve'
      post 'deny'
    end
  end
  resources :donations do
    member do
      post 'accept'
      post 'reject'
      post 'receive'
    end
  end

  resources :users do
    member do
      get 'show'
      post 'create'
      get 'donations'
      post 'update_user_role'
    end
    collection do
      post 'update_contact_details'
      get 'onboarding'
      get 'manage_users'
    end
  end

  resources :logs, only: [:index]

  get 'not_authorized' => 'home#not_authorized'
  get 'contact_us' => 'home#contact_us'
  match '*a', :to => 'errors#routing', :via => [:get]
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
