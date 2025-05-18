Rails.application.routes.draw do
  root "imports#new"
  resources :imports, only: [ :new ] do
    collection do
      post :preview
      post :import
    end
  end
  resources :import_jobs, only: [ :update ]
  get "dashboards/show"

  get "up" => "rails/health#show", as: :rails_health_check
end
