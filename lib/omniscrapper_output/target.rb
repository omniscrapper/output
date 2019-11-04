require_relative 'kafka/target'

module OmniScrapperOutput
  class NonExistingTarget < StandardError; end;
  class DeliveryFailed < StandardError; end;

  class Target
    def initialize(output_configuration)
      @klass = target_for(output_configuration[:target_type])
      @config = @klass::Configuration.new(output_configuration)
    end

    def call(data)
      @klass.call(@config, data)
      # TODO: catch adapter-specific exceptions here
      # and reraise generic gem DeliveryFailed
      # Kafka::DeliveryFailed => e
    end

    private

    def target_for(type)
      targets[type.to_sym] || raise(NonExistingTarget, type)
    end

    def targets
      {
        kafka: OmniScrapperOutput::Kafka::Target
      }
    end
  end
end
