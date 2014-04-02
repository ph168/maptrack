class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :csrf

  def csrf
    response.header['X-CSRF-Token'] = form_authenticity_token
  end
end
