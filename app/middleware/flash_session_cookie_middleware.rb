require 'rack/utils'

class FlashSessionCookieMiddleware
  def initialize(app, session_key = '_session_id')
    @app = app
    @session_key = session_key
  end

  def call(env)
    # Small hack to make sure sessions work for Flash objects
    if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
      req = Rack::Request.new(env)
      unless req.params[@session_key].nil?
        env['HTTP_COOKIE'] = "#{@session_key}=#{req.params[@session_key]}".freeze
      end
    end
    @app.call(env)
  end
end