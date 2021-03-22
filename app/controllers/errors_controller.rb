class ErrorsController < ApplicationController
  def error
    redirect_to root_url
  end
end