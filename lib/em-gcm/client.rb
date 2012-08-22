require "em-gcm/response"
require "em-gcm/log_message"

module EventMachine
  module GCM
    class Client
      URL = "https://android.googleapis.com/gcm/send"

      def initialize(notification)
        @notification = notification
      end

      def deliver_plain(block = nil)
        verify_token
        @start = Time.now.to_f

        http = EventMachine::HttpRequest.new(URL).post(
          :query  => @notification.params,
          :head   => @notification.headers_plain
        )

        http.callback do
          response = Response.new(http, @start)
          LogMessage.new(@notification, response).log
          block.call(response) if block          
        end

        http.errback do |e|
          EM::GCM.logger.error(e.inspect)
        end
      end

     def deliver_json(block = nil)
        verify_token
        @start = Time.now.to_f

        http = EventMachine::HttpRequest.new(URL).post(
          :body => @notification.body,
          :head   => @notification.headers_json
        )

        http.callback do
          response = Response.new(http, @start)
          LogMessage.new(@notification, response).log
          block.call(response) if block
        end

        http.errback do |e|
          EM::GCM.logger.error(e.inspect)
        end
      end

      private

      def verify_token
        raise "token not set!" unless EM::GCM.token
      end
    end
  end
end
