module Newscloud
  module Util

    # Thanks to restful_auth authentication.rb for these
    mattr_accessor :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :bad_email_message, :login_regex, :bad_login_message, :name_regex, :bad_name_message
    
    self.name_regex        = /\A[^[:cntrl:]\\<>\/&]*\z/              # Unicode, permissive
    self.bad_name_message  = "avoid non-printing characters and \\&gt;&lt;&amp;/ please.".freeze

    self.bad_login_message = "use only letters, numbers, and .-_@ please.".freeze
    self.login_regex       = /\A\w[\w\.\-_@]+\z/                     # ASCII, strict
    self.email_name_regex  = '[\w\.%\+\-]+'.freeze
    self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
    self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
    self.email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
    self.bad_email_message = "should look like an email address.".freeze

    def current_user
      @current_user ||= User.active.find(session[:user_id]) if session[:user_id]
    end

    # Store the given user id in the session.
    def set_current_user(new_user)
      session[:user_id] = new_user ? new_user.id : nil
      @current_user = new_user || false
    end

    def current_facebook_user
      nil
    end

    def logged_in?
      !! current_user
    end

    def authorized?
      false
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.  Set an appropriately modified
    #   after_filter :store_location, :only => [:index, :new, :show, :edit]
    # for any controller you want to be bounce-backable.
    def redirect_back_or_default(default)
      session[:return_to] = nil
      redirect_to(session[:return_to] || default)
    end
    
    def self.included(base)
      base.send :helper_method, :current_user, :current_user=, :logged_in?, :authorized?, :store_location, :redirect_back_or_default if base.respond_to? :helper_method
    end
  end
end
