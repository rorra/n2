class SessionsController < ApplicationController

  def new
  end

  def create
    #render :json => request.env["omniauth.auth"].to_json and return

    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])

    if authentication
      flash[:notice] = "Signed in successfully."
      # TODO:: sign_in_and_redirect(:user, authentication.user)
      #session[:user_id] = authentication.user_id
      set_current_user authentication.user
      redirect_back_or_default home_index_path
    elsif current_user
      current_user.build_authentication_from_omniauth!(omniauth)
      flash[:notice] = "Authentication successful."
      redirect_back_or_default home_index_path
    elsif omniauth['provider'] == 'facebook' and fb_user = User.find_facebook_user(omniauth['uid'])
      set_current_user fb_user
      #session[:user_id] = fb_user.id
      current_user.build_authentication_from_omniauth!(omniauth)
      flash[:notice] = "Authentication successful."
      redirect_back_or_default home_index_path
    else
      user = User.build_from_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        #session[:user_id] = user.id
        set_current_user user
        redirect_back_or_default home_index_path
        # TODO:: sign_in_and_redirect(:user, user)
      else
        render :json => {:authentications => user.authentications, :auth_errors => user.authentications.map {|a| a.errors.full_messages }, :errors => user.errors.full_messages, :user => user, :omniauth => omniauth}.to_json and return
        session[:omniauth] = omniauth.except('extra')
        redirect_back_or_default new_user_path
      end
    end

    return
      
      





    # old session
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      if canvas?
        redirect_back_or_default(home_index_path(:iframe => 'iframe'))
      else
        redirect_back_or_default(home_index_path)
      end
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    #session[:user_id] = nil
    set_current_user nil
    

    # TODO add back in
    redirect_back_or_default(home_index_path) and return


    # TODO UPDATE
    canvas = canvas?
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    if canvas
      redirect_back_or_default(home_index_path(:iframe => 'iframe'))
    else
      redirect_back_or_default(home_index_path)
    end
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
