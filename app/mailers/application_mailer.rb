class ApplicationMailer < ActionMailer::Base
  default from: "notifications@" + ENV['MAILER_HOST']
  layout 'mailer'
end