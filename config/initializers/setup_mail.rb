ActionMailer::Base.smtp_settings = {
	:port =>           '587',
    :address =>        'smtp.mandrillapp.com',
    :user_name =>      ENV['MANDRILL_USERNAME'],
    :password =>       ENV['MANDRILL_APIKEY'],
    :domain =>         'heroku.com',
    :authentication => :plain
}

# require 'development_mail_interceptor'
# ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?