class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:register, :register_user]
  
  def home
  end

  def register
  end

  def register_user
    user = User.create!(permitted_register_params)

    rand = SecureRandom.alphanumeric(500)
    secret_key = Rails.application.secrets.secret_key_base
    crypt = ActiveSupport::MessageEncryptor.new(secret_key[0..31], secret_key)
    qr_code_value = crypt.encrypt_and_sign(rand)

    cert = user.certificates.create!(qr_code: qr_code_value)
    cert_link = certificate_url(cert.id)
    send_sms(user, cert_link)
    redirect_to new_user_form_path
  end

  def send_sms(user, cert_link)
    message = "Dear #{user.first_name}, your certificate is ready. Please click on the link below to download it. #{cert_link}."
    At.send(user.phone_number, message)
  end

  def certificate
    @cert = Certificate.find(params[:id])
    @user = @cert.user

    qrcode = RQRCode::QRCode.new(@cert.qr_code)
    # @svg = qrcode.as_svg(
    #   color: "000",
    #   shape_rendering: "crispEdges",
    #   module_size: 11,
    #   standalone: true,
    #   use_path: true,
    #   viewbox: "0 0 24 30"
    # )
    png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 300
    )
    
    path = "public/qr_codes/#{@cert.id}.png"
    write_path = "#{Rails.root}/#{path}"
    @asset_path = "#{request.base_url}/#{path}"
    IO.binwrite(write_path, png.to_s)

    html = render_to_string 'certificate', formats: %i[html]
    filename = "certificate.pdf"
    render_pdf(html, filename, orientation: 'Portrait')
  end

  def permitted_register_params
    params.permit(:birthday, :date_of_birth, :national_id, :phone_number, :first_name, :last_name, :gender, :email)
  end

  def render_pdf(html, filename = nil, options = {})
    default_options = { 'margin-bottom': '1in', 'footer-spacing': 1, 'root_url': "#{request.base_url}/" }
    kit = PDFKit.new(html, default_options.merge(options))
    send_data kit.to_pdf, type: 'application/pdf', filename: filename
  end
end
