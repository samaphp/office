# app.rb

require 'rack'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'

class OfficeApp
  SETTINGS = YAML.load_file('settings.yml')
  WEBHOOK_URL = SETTINGS['webhook_url']

  def call(env)
    request = Rack::Request.new(env)

    case request.path
    when '/coffee'
      [200, { 'content-type' => 'text/plain' }, ['Good people']]
    when '/ready'
      post_to_google_chat("Ready message triggered! (via Ruby script)")
      [200, { 'content-type' => 'text/plain' }, ['Good people']]
    else
      [404, { 'content-type' => 'text/plain' }, ['Not Found']]
    end
  end

  private

  def post_to_google_chat(message)
    uri = URI.parse(WEBHOOK_URL)
    header = {'Content-Type': 'application/json'}
    body = { text: message }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = body

    response = http.request(request)
    #puts "Response from Google Chat: #{response.body}"
  end
end
