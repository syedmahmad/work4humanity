class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_us.subject
  #
  def contact_us(param)
    @user = {name: param[:name], phone: param[:phone], email: param[:email], message: param[:message]}
    @greeting = @user[:message]

    mail to: "info@fliclicks.com", from: @user[:email]
  end
end
