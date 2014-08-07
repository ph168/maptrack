#https://gist.github.com/jwo/1255275

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = User.new params
    if user.save
      render :json => user, :status => :created
    else
      warden.custom_failure!
      render :json => user.errors, :status => :unprocessable_entity
    end
  end
end
