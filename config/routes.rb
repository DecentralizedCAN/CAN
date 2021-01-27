Rails.application.routes.draw do
  resources :comments
  resources :discussions, only: [:create, :new, :show, :destroy]
  resources :polls


# MAIN STUFF
  get '/solver', to: 'problems#index', :as => :solver
  get '/brainstorm/post', to: 'problems#new', :as => :post_problem
  post '/solver/sponsor', to: 'criteria#sponsor', :as => :sponsor_criteria
  post '/solver/unsponsor', to: 'criteria#unsponsor', :as => :unsponsor_criteria
  post '/solver/dissent', to: 'criteria#dissent', :as => :dissent_criteria
  post '/solver/assent', to: 'criteria#assent', :as => :assent_criteria
  post '/problem/sponsor', to: 'problems#sponsor', :as => :sponsor_problem
  post '/problem/unsponsor', to: 'problems#unsponsor', :as => :unsponsor_problem
  get '/brainstorm/:problem_id', to: 'problems#show', :as => :issue
  get '/brainstorm/table/:problem_id', to: 'problems#table', :as => :brainstorm_table
  resources :problems, only: [:create, :destroy]

  resources :solutions, only: [:create]
  get '/brainstorm/:problem_id/proposal/new', to: 'solutions#new', :as => :new_solution
  get '/brainstorm/:problem_id/proposal/:solution_id', to: 'solutions#show', :as => :solution
  delete '/proposal/:solution_id', to: 'solutions#destroy', :as => :destroy_solution
  post '/solver/poll', to: 'solutions#poll', :as => :set_poll
  post '/quietpoll', to: 'polls#quiet_set', :as => :quiet_set_poll

  get '/activator', to: 'activities#index', :as => :activator
  get '/action/post', to: 'activities#new', :as => :post_action
  get '/action/activate', to: 'activities#activate', :as => :activate_action
  get '/action/:activity_id', to: 'activities#show', :as => :action
  get '/i/:activity_id', to: 'activities#invitation', :as => :invitation
  get '/action/participate/:roll_id', to: 'activities#commit', :as => :commit
  post '/activator/participate/:roll_id', to: 'activities#participate', :as => :participate
  post '/action/unparticipate/:roll_id', to: 'activities#unparticipate', :as => :unparticipate
  post '/activator/complete/:activity_id', to: 'activities#complete', :as => :complete
  post '/activator/dissent', to: 'activities#dissent', :as => :dissent_activity
  post '/activator/assent', to: 'activities#assent', :as => :assent_activity
  post '/solver/suggest/:solution_id', to: 'activities#suggest', :as => :suggest
  resources :activities, only: [:create, :destroy]

  get 'notifications', to: 'static#notifications', :as => :notifications
  get 'notification_redirect/:notification_id', to: 'static#notification_redirect', :as => :notification_redirect
  post 'notifications/clear_one/:notification_id', to: 'static#clear_notification', :as => :clear_notification
  post 'notifications/clear', to: 'static#clear_notifications', :as => :clear_notifications
  post 'notifications/broadcast_post/:post_id', to: 'notifications#broadcast_post', :as => :broadcast_post
  post 'notifications/broadcast_criterion/:criterion_id', to: 'notifications#broadcast_criterion', :as => :broadcast_criterion

  get 'choice', to: 'static#choice', :as => :choice
  get 'commitments', to: 'static#commitments', :as => :commitment
  # get '', to: 'static#main_feed', :as => :main_feed
  get '', to: 'static#welcome', :as => :main_feed
  get 'guide', to: 'static#documentation', :as => :documentation
  get 'manage', to: 'static#manage', :as => :manage

  get 'settings', to: 'settings#index', :as => :settings
  post 'settings_on', to: 'settings#turn_on', :as => :setting_on
  post 'settings_off', to: 'settings#turn_off', :as => :setting_off

  get '/criteria/show/:criterium_id', to: 'criteria#show', :as => :show_criterium
  get '/criteria/full/:problem_id', to: 'criteria#full', :as => :full_criterium
  get '/criteria/dissent/:criterium_id', to: 'criteria#dissent_form', :as => :dissent_criterium
  get '/criteria/new', to: 'criteria#new', :as => :new_criterium
  post '/criteria/add', to: 'criteria#add', :as => :add_criterium
  resources :criteria, only: [:create, :destroy]

  post '/criteria/alt', to: 'criteria#alt', :as => :alt_criterium
  post '/criteria/accept_alt', to: 'criteria#accept_alt', :as => :accept_alt

  resources :goals, only: [:create, :index]
  get '/goal/new', to: 'goals#new', :as => :new_goal
  get '/goal/:goal_id', to: 'goals#show', :as => :goal
  get '/goal/details/:goal_id', to: 'goals#details', :as => :goal_details
  post '/newlink', to: 'goals#newlink', :as => :newlink
  post '/link', to: 'goals#link', :as => :link
  post '/path/leave/:link_id', to: 'goals#unlink', :as => :unlink
  post '/goal/complete/:goal_id', to: 'goals#complete_goal', :as => :complete_goal
  post '/goal/uncomplete/:goal_id', to: 'goals#uncomplete_goal', :as => :uncomplete_goal
  post '/goal/delete/:goal_id', to: 'goals#delete', :as => :delete_goal

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
  # root   'static#main_feed'
  root   'static#welcome'
  get    '/dashboard', to: 'static#dashboard'
  get    '/signup',  to: 'users#new'
  get    '/add',  to: 'users#add'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  post '/logout',  to: 'sessions#destroy'
  post '/user/:id/update_settings',  to: 'users#update_settings', :as => :update_settings
  post '/user/instant_activation/:id', to: 'users#instant_activation', :as => :retry_activation
  post '/user/make_admin/:id', to: 'users#make_admin', :as => :make_admin
  post '/user/remove_admin/:id', to: 'users#remove_admin', :as => :remove_admin
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end