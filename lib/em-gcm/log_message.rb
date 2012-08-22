module EventMachine
  module GCM
    class LogMessage
      def initialize(notification, response)
        @notification, @response = notification, response
      end

      def log
        if @response.success?
          EM::GCM.logger.info(message)
        else
          EM::GCM.logger.error(message)
        end
      end

      private

      def message
        parts = [
          "CODE=#{@response.status}",
          "GUID=#{@notification.uuid}",
          "TIME=#{@response.duration}",
          "TOKEN=#{@notification.registration_ids}"
        ]
        parts << "ERROR=#{@response.error}" unless @response.success?
        parts.join(" ")
      end
    end
  end
end
