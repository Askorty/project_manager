# typed: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  rescue_from StandardError, with: :render_internal_error unless Rails.env.development?

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def render_not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end

  def render_internal_error(exception)
    render file: Rails.root.join("public", "500.html"), status: :internal_server_error, layout: false
  end

  def record_invalid(exception)
    redirect_back fallback_location: root_path, alert: "Ошибка сохранения: #{exception.message}"
  end
end
