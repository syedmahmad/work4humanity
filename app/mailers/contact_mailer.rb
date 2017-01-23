class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_us.subject
  #
  def contact_us(param)
    @user = {name: param[:name], email: param[:email], message: param[:message]}
    @greeting = @user[:message]

    mail to: "devzaeem.khan@gmail.com", from: @user[:email]
  end
end
