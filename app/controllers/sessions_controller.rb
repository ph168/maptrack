#https://gist.github.com/jwo/1255275

class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create ]
  respond_to :json

  def create
    resource = User.find_for_database_authentication(:email => params[:email])
    return failure unless resource

    if resource.valid_password?(params[:password])
      sign_in("user", resource)
      render :status => 200, :json => { :success => true, :user => current_user }
    else
      failure
    end
  end

  def destroy
    sign_out(resource_name)
    render :status => 200, :json => { :success => true }
  end

  def failure
    render :status => 401, :json => { :success => false }
  end
end
