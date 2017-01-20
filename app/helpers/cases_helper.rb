module CasesHelper
  def redirect_user_path
    if Rails.application.routes.recognize_path(request.referer)[:controller].downcase == "users"
      cases_user_path(current_user)
    else
      cases_path
    end
  end
end
