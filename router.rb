# router.rb

class RequestRouter
  attr_reader :current_request

  def initialize(app)
    @app = app
  end

  def handle_request(request)
    @current_request = request # Expose current request for IP address retrieval

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
      status_code, message = @app.can_access?('coffee_ready')
      if status_code == 200
        status_code, status_message = @app.post_to_google_chat("Ready message triggered! (via Ruby script)")
        [302, { 'location' => '/coffee?status=ready' }, []]
      else
        @app.serve_html('coffee/index.html', message: message)
      end

    when '/coffee/finish'
      status_code, message = @app.can_access?('coffee_finish')
      if status_code == 200
        status_code, status_message = @app.post_to_google_chat("Finish message triggered! (via Ruby script)")
        [302, { 'location' => '/coffee?status=finish' }, []]
      else
        @app.serve_html('coffee/index.html', message: message)
      end
    else
      @app.serve_html('404.html', 404)
    end
  end
end