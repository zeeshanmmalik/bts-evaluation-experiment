BtsEvalExpApp::Application.routes.draw do

  resources :experiments do
    member do
      get 'result'
      get 'export_results_for'
      get 'export_bug_summaries_for'
      get 'q3_result'
      get 'q4_text_result'
      get 'q5_text_result'
    end
    collection do
      get 'all_results'
      get 'q3_all_results'
      get 'q4_text_all_results'
      get 'q5_text_all_results'
      get 'export_results_for_all'
      get 'export_bug_summaries_for_all'
    end
  end

  resources :emails

  resources :participants, :only => [] do
    member do
      get 'send_invitation_email'
    end
  end

  match 'survey/:access_token/access' => 'survey#access', :via => :get, :as => 'access_survey'
  match 'survey/:access_token/submit' => 'survey#submit', :via => :put, :as => 'submit_survey'
  match 'survey/:access_token/thanks' => 'survey#thanks', :via => :get, :as => 'thanks_survey'

  resources :bug_reports, :only => [:index, :show] do
    member do
      get 'compare_summary'
    end
  end

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

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
  root :to => 'experiments#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end
end
