require 'waterdrop'
require 'logger'

module OmniScrapperOutput
  module Kafka
    class Target
      def self.call(configuration, data)
        # TODO: not thread safe
        @configured ||= WaterDrop.setup do |config|
                          config.client_id = 'scrapper'
                          config.deliver = true
                          config.kafka.seed_brokers = ["kafka://#{configuration.kafka_host}:9092"]
                          config.logger = Logger.new(STDOUT)
                        end
        new(configuration).call(data)
      end

      attr_reader :config

      def initialize(config)
        @config = config
      end

      def call(data)
        WaterDrop::SyncProducer.call(
          serialize(data),
          topic: @config.output_topic
        )
      end

      private

      def serialize(data)
        JSON.dump(data)
      end

      # TODO add validation of incoming configuration
      # probably it should done during storage initialization,
      # but on the other hand scrappers don't have output
      # configuration before task is emerged.
      # So for multi-user environment it should be defined at the moment of task
      # spawn.
      class Configuration < Dry::Struct
        attribute :target_type, Types::String.optional

        attribute :kafka_host, Types::String.optional
        attribute :output_topic, Types::String.optional
      end
    end
  end
end
