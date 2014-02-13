class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :store_location

	def store_location
	  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
	  if (request.fullpath != "/users/sign_in" &&
	      request.fullpath != "/users/sign_up" &&
	      request.fullpath != "/users/password" &&
	      request.fullpath != "/users/sign_out" &&
	      !request.xhr?) # don't store ajax calls
	    session[:previous_url] = request.fullpath 
	  end
	end

	def after_sign_in_path_for(resource)
		previous_url = session[:previous_url]
		session[:previous_url] = nil
	  previous_url || ""
	end

end
