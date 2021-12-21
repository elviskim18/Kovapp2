class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:register, :register_user]
  
  def home
  end

  def register
  end

  def register_user
    user = User.create!(permitted_register_params)
    binding.pry
    redirect_to new_user_form_path
  end

  def permitted_register_params
    params.permit(:birthday, :date_of_birth, :national_id, :phone_number, :first_name, :last_name, :gender, :email)
  end
end
