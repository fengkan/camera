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
    else
      flash[:notice_class] = 'n_failure'
      flash.now[:notice] = "您输入的用户名或密码不正确，请重试"
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default(:controller => '/misc', :action => 'index')
	end
	
	def forgetpwd
    return unless request.post?
    u = User.find_by_email(params[:email])
    if u.nil?
      flash[:notice_class] = 'n_failure'
	    flash.now[:notice] = "未能找到匹配的用户，请重试"
  	else
  		u.reset_password_token = Digest::SHA1.hexdigest("--#{Time.now.to_s}--")
  		u.reset_password_sent_at = Time.now
  		u.save
	    Resque.enqueue(UserNotification, "reset_password", u.id)
      flash[:notice_class] = 'n_success'
	    flash.now[:notice] = "我们已将用于登入的连接发送到您的信箱，快去看看吧"
  	end
	end
	
	def reset
		reset_id = params[:r]
    u = User.find_by_reset_password_token(reset_id, :conditions => ['reset_password_sent_at >= ?', Date.today - 1])
    if u.nil?
      flash[:notice_class] = 'n_failure'
	    flash.now[:notice] = "您用于登入的连接有误，或者已经超过有效期，请重试"
			render :action => :forgetpwd
  	else
			self.current_user = u
      flash[:notice_class] = 'n_success'
	    flash[:notice] = "您已登入，请设置新的登入密码"
			redirect_to :action => :newpwd
		end
	end
	
	def newpwd
    return unless request.post?
  	current_user.password = params[:user_password]
  	current_user.password_confirmation = params[:user_password]
  	current_user.save
    flash[:notice_class] = 'n_success'
    flash.now[:notice] = "密码设置成功！"
	end
end
