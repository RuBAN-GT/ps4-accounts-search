Rails.application.routes.draw do
  scope :module => :web do
    root 'pages#index'

    resources :posts, :only => %w(index)
  end

  namespace :api, :defaults => {:format => :json} do
    namespace :v1, :constraints => ApiVersion.new(1) do
      resources :sources, :only => %w(index show)
      resources :posts, :only => %w(index show)
    end
  end
end
