# to register a new user:
#   method: POST
#   route:  /api/registrations?username=USERNAME_HERE&email=EMAIL_HERE&password=PASSWORD_HERE

class Api::RegistrationsController < ApplicationController
  respond_to :json

  def create
    user = User.new(params)

    if user.save
      render :json => user.as_json(:auth_token=>user.authentication_token, :email=>user.email), :status => 201
      return
    else
      warden.custom_failure!
      render :json => user.errors, :status => 422
    end
  end
end