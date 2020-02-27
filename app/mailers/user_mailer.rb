class UserMailer < ApplicationMailer
    default from: "valentinesglobal7@gmail.com"

    def welcome_email
        @user = params[:email]
        @username = params[:username]
        @url = 'http://localhost:3000/users/new'
        mail(to: @user , subject: 'Welcome to my awesome site')
    end
end
