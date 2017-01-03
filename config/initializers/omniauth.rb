Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['368123226881871'], ENV['8e96d2e97691430047f96856adde34b5']
end