# router.rb

class RequestRouter
  attr_reader :current_request

  def initialize(app)
    @app = app
  end

  def handle_request(request)
    @current_request = request # Expose current request for IP address retrieval
    user_name = @app.get_user_name(request)

    case request.path
    when '/coffee'
      status_param = request.params['status']
      case status_param
      when 'ready'
        message = "Coffee is ready event has been triggered"
      when 'finish'
        message = "Coffee has finished event has been triggered"
      else
        message = ''
      end
      @app.serve_html('coffee/index.html', message: message)

    when '/coffee/ready'
      @app.apply_rate_limit!('coffee_ready')
      status_code, status_message = @app.post_to_google_chat("القهوة جاهزة ☕\n#{user_name}")
      [302, { 'location' => '/coffee?status=ready' }, []]

    when '/coffee/finish'
      @app.apply_rate_limit!('coffee_finish')
      status_code, status_message = @app.post_to_google_chat("خلصت القهوة 🚫\n#{user_name}")
      [302, { 'location' => '/coffee?status=finish' }, []]

    when '/name'
      user_name = request.params['name']
      [302, { 'set-cookie' => "user_name=#{user_name}; path=/", 'location' => '/coffee' }, []]

    else
      @app.serve_html('404.html', 404)
    end

  end
end