class AuthenticationController < ApiController
  skip_before_action :authenticate_request
 
  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])
 
    if command.success?
      render json: { auth_token: command.result }
    else
      error = command.errors.first
      render json: { error: error[1] }, status: :unauthorized
    end
  end
 end
