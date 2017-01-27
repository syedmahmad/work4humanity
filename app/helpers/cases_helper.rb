module CasesHelper
  def redirect_user_path
    if Rails.application.routes.recognize_path(request.referer)[:controller].downcase == "users"
      cases_user_path(current_user)
    elsif Rails.application.routes.recognize_path(request.referer)[:controller].downcase == "logs"
      logs_path
    else
      cases_path
    end
  end
end
