module Hitimes
  #
  # Metric hold the common meta information for all derived metric classes
  #
  # All metrics hold the meta information of:
  #
  # * The name of the metric
  # * The time of day the first measurement is taken
  # * The time of day the last measurement is taken
  # * additional data 
  #
  # Each derived class is assumed to set the sampling_start_time and
  # sampling_stop_time appropriately.
  # 
  # Metric itself should generally not be used.  Only use the derived classes.
  #
  class Metric

    # the time at which the first sample was taken
    # This is the number of microseconds since UNIX epoch as a Float in UTC
    attr_accessor :sampling_start_time

    # the time at which the last sample was taken.
    # This is the number of microseconds since UNIX epoch as a Float in UTC
    attr_accessor :sampling_stop_time

    # An additional hash of data to associate with the metric
    attr_reader :additional_data

    # The 'name' to associate with the metric
    attr_reader :name

    #
    # :call-seq:
    #   Metric.new( 'my_metric' ) -> Metric
    #   Metric.new( 'my_metric', 'foo' => 'bar', 'this' => 42 ) -> Metric
    #
    # Create a new ValueMetric giving it a name and additional data.
    #
    # +additional_data+ may be anything that follows the +to_hash+ protocol.
    # +name+ may be anything that follows the +to_s+ protocol.
    #
    def initialize( name, additional_data = {} )
      @sampling_start_time = nil
      @sampling_stop_time  = nil
      @name                = name.to_s
      @additional_data     = additional_data.to_hash
    end

    #
    # :call-seq:
    #   metric.utc_microseconds -> Float
    #
    # The current time in microseconds from the UNIX Epoch in the UTC
    #
    def utc_microseconds
      Time.now.gmtime.to_f * 1_000_000
    end
  end
end
