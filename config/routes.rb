Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: redirect('/api/matrix/compute')

  namespace :api do
      resources :matrix do
        get :compute, on: :collection
      end
    end

end
