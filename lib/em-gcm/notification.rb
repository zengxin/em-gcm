require 'json'

module EventMachine
  module GCM
    class Notification
      attr_reader :uuid, :options, :registration_ids

      def initialize(registration_ids, options = {})
        @registration_ids, @options = registration_ids, options
        raise ArgumentError.new("missing options") if options.nil? || options.empty?
        @uuid = $uuid.generate
      end

      def params
        @params ||= generate_params
      end

      def body
        @body ||= generate_body
      end

      def headers_plain
        {
          "Authorization"   => "key=#{EM::GCM.token}",
          "Content-Type"    => "application/x-www-form-urlencoded;charset=UTF-8",
          "User-Agent"      => "em-c2dm 1.0.0"
        }
      end

      def headers_json
        {
          "Authorization"   => "key=#{EM::GCM.token}",
          "Content-Type"    => "application/json",
          "User-Agent"      => "em-c2dm 1.0.0"
        }
      end


      private

      def generate_params
        params = { "registration_id" => @registration_ids[0] }
        params["collapse_key"] = @options.delete(:collapse_key) || @options.delete("collapse_key")
        @options.each do |k,v|
          params["data.#{k}"] = v
        end
        params
      end
  
      def generate_body
        body_hash = {}
        body_hash[:collapse_key] = @options.delete(:collapse_key) || @options.delete("collapse_key")
        body_hash[:data] = @options
        body_hash[:registration_ids] = @registration_ids
        body_hash.to_json
      end
      
    end
  end
end
