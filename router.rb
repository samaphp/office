# router.rb

class RequestRouter
  def initialize(app)
    @app = app
  end

  def handle_request(request)
    case request.path

    when '/coffee'
      @app.serve_html('coffee/index.html')

    when '/coffee/ready'
      status_code, status_message = @app.post_to_google_chat("Ready message triggered! (via Ruby script)")
      result_message = "#{status_code} #{status_message}"
      @app.serve_html('coffee/ready.html', message: result_message)

    when '/coffee/finish'
      status_code, status_message = @app.post_to_google_chat("Finish message triggered! (via Ruby script)")
      result_message = "#{status_code} #{status_message}"
      @app.serve_html('coffee/finish.html', message: result_message)

    else
      @app.serve_html('404.html', 404)
    end
  end
end
