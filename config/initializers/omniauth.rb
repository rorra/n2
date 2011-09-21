ActionController::Dispatcher.middleware.use OmniAuth::Builder do
  provider :facebook, '189970861891', '6339e953ad2d278db85e3e83914cdd60', {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
  provider :twitter, 'evv6Ua7vFLzvwNrUt41oyg', 'jtKfrHEFZVZ318AFK57GkQRfDLzB4yScG2IDrmyED8'
end