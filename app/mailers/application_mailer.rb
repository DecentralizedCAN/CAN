class ApplicationMailer < ActionMailer::Base
  default from: "notifications@" + ENV['SERVER_HOST'] + ".com"
  layout 'mailer'
end