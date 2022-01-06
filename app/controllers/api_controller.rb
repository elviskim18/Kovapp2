class ApiController < ApplicationController
  before_action :authenticate_request
  attr_reader :current_user

  def user
    render json: { first_name: @current_user.first_name, last_name: @current_user.last_name, email: @current_user.email }
  end

  def verify
    qr = params[:qr_code]
    # we fetch out secret key from out application secrets
    secret_key = Rails.application.secret_key_base
    # we decrypt and verify the qr code using the secret key
    crypt = ActiveSupport::MessageEncryptor.new(secret_key[0..31], secret_key)
    # if the verification fails, and exception will be raised which is handled in line 26
    crypt.decrypt_and_verify(qr)
    # beyond here, we are sure the the qr code is valid
    certificate = Certificate.includes(:user).find_by(qr_code: qr)
    user = certificate.user
    render json: {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      national_id: user.national_id
    }
    # when the qr code is invalid we return an invalid message that is sent to the mobile app
    rescue
      render json: { error: 'Invalid QR Code' }, status: 400
  end

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end