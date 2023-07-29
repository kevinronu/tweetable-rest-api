class ApplicationController < ActionController::Base
  before_action :authenticate_user, except: %i[index show]
  helper_method %i[current_user user_signed_in?]

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !session[:user_id].nil?
  end

  def log_in(user)
    session[:user_id] = user.id
    flash.now[:info] = "You are now logged in"
  end

  def logout
    session.delete(:user_id)
    flash.now[:info] = "Thanks for using Tweetable"
  end

  def authenticate_user
    return nil if user_signed_in?

    flash[:message] = "You need to be logged in to perform this action"
    redirect_to login_path
  end
end
