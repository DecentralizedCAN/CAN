class ApplicationMailer < ActionMailer::Base
  default from: "notifications@" + ENV['SERVER_HOST']
  layout 'mailer'
end