# app.rb

require 'rack'
require 'net/http'
require 'uri'
require 'json'
require 'yaml'
require 'thread'
require 'time'
require_relative '../router'

class AccessDenied < StandardError; end

class OfficeApp
  SETTINGS = YAML.load_file('settings.yml')
  VIEW_PATH = File.join(__dir__, '../views')

  RATE_LIMIT_PERIOD = 600 # 10 minutes in seconds
  CLEANUP_INTERVAL = 10 # Cleanup interval in seconds
  RATE_LIMIT_CACHE = {} # In-memory store for tracking request timestamps

  def initialize
    @request_router = RequestRouter.new(self)
    start_cleanup_thread
  end

  def apply_rate_limit!(action_name)
    current_time = Time.now.to_i
    client_ip = @request_router.current_request.ip # Assuming you have a way to get client IP address

    # Generate a key based on action name and client IP
    key = "#{action_name}:#{client_ip}"

    if RATE_LIMIT_CACHE[key]
      last_request_time = RATE_LIMIT_CACHE[key]
      if current_time - last_request_time < RATE_LIMIT_PERIOD
        remaining_time = (RATE_LIMIT_PERIOD - (current_time - last_request_time)) / 60.0
        message = "Rate limit exceeded. Please try again in #{remaining_time.ceil} minutes."
        raise AccessDenied, "Rate limit exceeded. Please try again in #{remaining_time.ceil} minutes."
      else
        RATE_LIMIT_CACHE[key] = current_time
      end
    else
      RATE_LIMIT_CACHE[key] = current_time
    end
  end

  def start_cleanup_thread
    Thread.new do
      loop do
        sleep(CLEANUP_INTERVAL)
        cleanup_expired_cache
      end
    end
  end

  def cleanup_expired_cache
    current_time = Time.now.to_i
    RATE_LIMIT_CACHE.delete_if do |key, timestamp|
      current_time - timestamp >= RATE_LIMIT_PERIOD
    end
  end

  def call(env)
    request = Rack::Request.new(env)
    begin
      @request_router.handle_request(request)
    rescue AccessDenied => e
      serve_html('coffee/index.html', message: e.message)
    end
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
    message ||= ''
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
