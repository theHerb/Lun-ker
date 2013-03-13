ActionMailer::Base.smtp_settings = {
	:address				=> "smtp.gmail.com",
	:port					=> 587,
	:domain					=> "gmail.com",
	:user_name				=> "msh.cal.ab@gmail.com",
	:password				=> "Summer66",
	:authentication			=> "plain",
	:enable_starttls_auto	=> true
}

require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?