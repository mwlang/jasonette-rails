class TestController < ActionController::Base
end

def test_view_context_class
  controller = TestController.new
  controller.request = ActionDispatch::Request.empty
  controller.view_context
end

class JsonView
  attr_reader :controller
  def initialize(env = {})
    @controller = TestController.new
    controller.request = ActionDispatch::Request.new(default_env.merge(env))
  end

  def render(view, **locals)
    controller.render_to_string(view, locals: locals)
  end

  def https?
    @_https ||= ENV.fetch("SERVER_HTTPS") {
      Rails.application.config.force_ssl
    }
  end

  def default_env
    {
      "SERVER_NAME"     => ENV.fetch("SERVER_NAME") {
        abort "Missing environment key: SERVER_NAME"
      },
      "SERVER_PORT"     => https? ? "443" : "80",
      "HTTPS"           => https? ? "on" : "off",
      "rack.url_scheme" => https? ? "https" : "http",
      "CONTENT_TYPE"   => "application/json",
      "HTTP_ACCEPT"    => "application/json",
    }
  end

  # Helpful shim reaching into the controller private stuff
  def location_url(beacons)
    controller.send(:location_url, beacons)
  end

  def respond_to_missing?(meth, include_all)
    controller.respond_to?(meth) || super
  end

  def method_missing(sym, *args, &block)
    if controller.respond_to?(sym)
      controller.send(sym, *args, &block)
    else
      super
    end
  end
end
