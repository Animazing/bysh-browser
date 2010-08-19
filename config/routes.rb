Byshbrowser::Application.routes.draw do

  namespace :admin do |admin|
    resources :users
  end
  
  resource :user_sessions
  # Browser matches
  match 'browsers/*path' => 'folders#show'
  match 'download/*path' => 'folders#create'

  match 'zip/*path' => 'folders#zip'  
  match 'browsers/' => 'folders#show'

  resource :folders
  resources :short_links
  
 root :to => "folders#show"
end
