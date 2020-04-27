Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "cards/index" => "cards#index"
 post "cards/check" => "cards#post"
  mount API::Root => '/api/'

end
