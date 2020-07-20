class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :edit, :update]
  access all: [:show, :index], user: {except: [:destroy]}, editor: {except: [:destroy]}, admin: :all
  def index
    if user_signed_in?
      if current_user.admin?
        @users = User.all
      elsif current_user.editor?
        @users = User.where.not(roles: "admin")
      else
        @users = User.where(id: current_user.id)
      end
    end
  end

  def edit
  end

  def show
  end

  def update
    respond_to do |format|
      debugger
      if @user.update!(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if User.where(id: params[:id]).present?
        @user = User.find(params[:id])
        unless current_user.editor? || current_user.admin?
          unless @user == current_user
            redirect_to root_path, alert: 'No such Access'
          end
        end
      else
        redirect_to root_path, alert: 'No such user available'
      end
    end
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :address, roles: [])
    end
end
