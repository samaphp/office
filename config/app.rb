# app.rb

require 'rack'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require_relative '../router'

class OfficeApp
  SETTINGS = YAML.load_file('settings.yml')
  VIEW_PATH = File.join(__dir__, '../views')

  def initialize
    @request_router = RequestRouter.new(self)
  end

  def call(env)
    request = Rack::Request.new(env)
    @request_router.handle_request(request)
  end

  def post_to_google_chat(message)
    uri = URI.parse(SETTINGS['webhook_url'])
    header = { 'content-type': 'application/json' }
    body = { text: message }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body

    begin
      response = http.request(request)
      status_code = response.code.to_i
      status_message = response.message
      [status_code, status_message]
    rescue StandardError => e
      [500, "Internal Server Error: #{e.message}"]
    end
  end

  def serve_html(filename, status = 200, message: '', title: 'My Application')
    file_path = File.join(VIEW_PATH, filename)
    layout_path = File.join(VIEW_PATH, 'layout.html')
    if File.exist?(file_path) && File.exist?(layout_path)
      content = File.read(file_path)
      layout = File.read(layout_path)
      page_content = layout.gsub('{{title}}', title)
                          .gsub('{{content}}', content)
                          .gsub('{{message}}', message)

      [status, { 'content-type' => 'text/html' }, [page_content]]
    else
      [404, { 'content-type' => 'text/plain' }, ['File Not Found']]
    end
  end
end
