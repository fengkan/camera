#encoding: utf-8

require 'date'
require 'digest/sha1'

class AccountsController < ApplicationController
  include ApplicationHelper

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login_email], params[:login_password])
    if logged_in?

      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/misc', :action => 'index')
      flash.now[:notice] = "登入成功"
    else
      flash.now[:notice] = "您输入的用户名或密码不正确，请重试"
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash.now[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/misc', :action => 'index')
	end
end
