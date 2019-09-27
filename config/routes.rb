Rails.application.routes.draw do
  resources :comments
  resources :discussions, only: [:create, :new, :show, :destroy]
  resources :polls


# MAIN STUFF
  get '/solver', to: 'problems#index', :as => :solver
  get '/solver/post', to: 'problems#new', :as => :post_problem
  post '/solver/sponsor', to: 'criteria#sponsor', :as => :sponsor_criteria
  post '/solver/unsponsor', to: 'criteria#unsponsor', :as => :unsponsor_criteria
  post '/solver/dissent', to: 'criteria#dissent', :as => :dissent_criteria
  post '/solver/assent', to: 'criteria#assent', :as => :assent_criteria
  post '/problem/sponsor', to: 'problems#sponsor', :as => :sponsor_problem
  post '/problem/unsponsor', to: 'problems#unsponsor', :as => :unsponsor_problem
  get '/solver/:problem_id', to: 'problems#show', :as => :issue
  resources :problems, only: [:create, :destroy]

  resources :solutions, only: [:create]
  get '/solver/:problem_id/solution/new', to: 'solutions#new', :as => :new_solution
  get '/solver/:problem_id/solution/:solution_id', to: 'solutions#show', :as => :solution
  delete '/solution/:solution_id', to: 'solutions#destroy', :as => :destroy_solution
  post '/solver/poll', to: 'solutions#poll', :as => :set_poll

  get '/activator', to: 'activities#index', :as => :activator
  get '/activator/post', to: 'activities#new', :as => :post_action
  get '/activator/activate', to: 'activities#activate', :as => :activate_action
  get '/activator/:activity_id', to: 'activities#show', :as => :action
  get '/activator/participate/:roll_id', to: 'activities#commit', :as => :commit
  post '/activator/participate/:roll_id', to: 'activities#participate', :as => :participate
  post '/activator/complete/:activity_id', to: 'activities#complete', :as => :complete
  post '/activator/dissent', to: 'activities#dissent', :as => :dissent_activity
  post '/activator/assent', to: 'activities#assent', :as => :assent_activity
  post '/solver/suggest/:solution_id', to: 'activities#suggest', :as => :suggest
  resources :activities, only: [:create, :destroy]

  get 'commitments', to: 'static#commitments', :as => :commitment
  get 'notifications', to: 'static#notifications', :as => :notifications
  get '', to: 'static#main_feed', :as => :main_feed
  get 'guide', to: 'static#documentation', :as => :documentation
  get 'manage', to: 'static#manage', :as => :manage

  get '/criteria/show/:criterium_id', to: 'criteria#show', :as => :show_criterium
  get '/criteria/full/:problem_id', to: 'criteria#full', :as => :full_criterium
  get '/criteria/dissent/:criterium_id', to: 'criteria#dissent_form', :as => :dissent_criterium
  get '/criteria/new', to: 'criteria#new', :as => :new_criterium
  post '/criteria/add', to: 'criteria#add', :as => :add_criterium
  resources :criteria, only: [:create, :destroy]

  post '/criteria/alt', to: 'criteria#alt', :as => :alt_criterium
  post '/criteria/accept_alt', to: 'criteria#accept_alt', :as => :accept_alt

  # TEMPORARY
  # resources :posts do
  #   resources :upvotes
  # end
  post '/comments/upvote/:post_id', to: 'upvotes#upvote', :as => :upvote
  post '/comments/unupvote/:post_id', to: 'upvotes#unupvote', :as => :unupvote

  post '/comments/like/:comment_id', to: 'upvotes#like', :as => :like
  post '/comments/unlike/:comment_id', to: 'upvotes#unlike', :as => :unlike

  resources :comments, only: [:destroy]

  delete '/main_feed/:post_id', to: 'static#destroy', :as => :delete_post


# MAIN STUFF ENDS

  get 'wakemydyno.txt', to: 'static#wakemydyno'



  get 'password_resets/new'
  get 'password_resets/edit'

  # root   'static#commitments'
  root   'static#main_feed'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  post '/logout',  to: 'sessions#destroy'
  post '/user/:id/update_settings',  to: 'users#update_settings', :as => :update_settings
  post '/user/instant_activation/:id', to: 'users#instant_activation', :as => :retry_activation
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end