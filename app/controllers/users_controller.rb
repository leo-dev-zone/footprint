class UsersController < ApplicationController
  load_and_authorize_resource :user
  respond_to :html

  def index
    respond_with @users
  end

  def show
    respond_with @user
  end

  def new
    respond_with @user
  end

  def edit
    respond_with @user
  end

  def create
    role = params[:user].delete(:role)
    @user.role = role if role && current_user.admin?
    flash[:notice] = 'User was successfully created.' if @user.save
    respond_with @user
  end

  def update
    role = params[:user].delete(:role)
    @user.role = role if role && current_user.admin?
    flash[:notice] = 'User was successfully created.' if @user.update_attributes(params[:user])
    respond_with @user
  end

  def destroy
    @user.destroy
    flash[:notice] = 'User was successfully destroyed.'
  end
end
