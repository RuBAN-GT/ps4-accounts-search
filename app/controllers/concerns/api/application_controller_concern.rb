module Api::ApplicationControllerConcern
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :null_session
  end
end
