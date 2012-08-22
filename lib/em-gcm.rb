$:.unshift File.dirname(__FILE__)

require "eventmachine"
require "em-http-request"
require "logger"
require "uuid"
require "em-gcm/client"
require "em-gcm/notification"

$uuid = UUID.new

module EventMachine
  module GCM
    class << self
      def push_plain(registration_ids, options, &block)
        notification = Notification.new(registration_ids, options)
        Client.new(notification).deliver_plain(block)
      end

      def push_json(registration_ids, options, &block)
        notification = Notification.new(registration_ids, options)
        Client.new(notification).deliver_json(block)
      end

      def token=(token)
        logger.info("setting new auth token")
        @token = token
      end

      def token
        @token
      end

      def logger
        @logger ||= Logger.new(STDOUT)
      end

      def logger=(new_logger)
        @logger = new_logger
      end
    end
  end
end
