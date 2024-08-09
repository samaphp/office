# app.rb

require 'rack'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'

class OfficeApp
  SETTINGS = YAML.load_file('settings.yml')
  WEBHOOK_URL = SETTINGS['webhook_url']
  VIEW_PATH = File.join(__dir__, 'views')

  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when '/coffee'
      serve_html('coffee/index.html')
    when '/coffee/ready'
      post_to_google_chat("Ready message triggered! (via Ruby script)")
      serve_html('coffee/ready.html')
    else
      serve_html('404.html', 404)
    end
  end

  private

  def post_to_google_chat(message)
    uri = URI.parse(WEBHOOK_URL)
    header = { 'content-type': 'application/json' }
    body = { text: message }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body

    response = http.request(request)
    #puts "Response from Google Chat: #{response.body}"
  end

  def serve_html(filename, status = 200)
    file_path = File.join(VIEW_PATH, filename)
    if File.exist?(file_path)
      content = File.read(file_path)
      [status, { 'content-type' => 'text/html' }, [content]]
    else
      [404, { 'content-type' => 'text/plain' }, ['File Not Found']]
    end
  end
end
