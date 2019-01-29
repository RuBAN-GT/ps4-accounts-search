class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  unless Rails.env.development?
    rescue_from ActionController::RoutingError,
      ActionController::UnknownController,
      ::AbstractController::ActionNotFound,
      ActiveRecord::RecordNotFound,
      ActionController::UnknownFormat,
      ActionController::InvalidCrossOriginRequest,
      :with => :handle_error_404

    rescue_from ActionDispatch::ParamsParser::ParseError,
      ActionController::ParameterMissing,
      :with => :handle_error_400
  end

  def param_current_page
    params.permit(:page => %w(number)).dig :page, :number
  end
  def param_per_page
    params.permit(:page => %w(size)).dig :page, :size
  end

  protected

    def handle_error_404
    end
    def handle_error_400
    end
end
