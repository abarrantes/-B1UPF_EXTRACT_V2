class LicenseUsersController < ApplicationController
  before_action :set_license_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @license_users = LicenseUser.includes(:license_modules)

    # Apply search filter
    if params[:search].present?
      @license_users = @license_users.where("user_name ILIKE ?", "%#{params[:search]}%")
    end

    # Apply module type filter
    if params[:module_type].present?
      @license_users = @license_users.joins(:license_modules)
                                   .where(license_modules: { key_type: params[:module_type] })
                                   .distinct
    end

    # Apply connection status filter
    if params[:connection_status].present?
      @license_users = @license_users.where(is_connected: params[:connection_status])
    end

    @license_users = @license_users.page(params[:page]).per(20)
  end

  def show
  end

  def edit
  end

  def update
    if @license_user.update(license_user_params)
      redirect_to @license_user, notice: "License user was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @license_user.destroy
    redirect_to license_users_url, notice: "License user was successfully deleted."
  end

  private

  def set_license_user
    @license_user = LicenseUser.find(params[:id])
  end

  def license_user_params
    params.require(:license_user).permit(:user_name, :is_connected)
  end
end
