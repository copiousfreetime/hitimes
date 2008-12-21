require 'hitimes'
require 'thread'

module Hitimes
  class MutexedStats < Stats
    def initialize
      @mutex = Mutex.new
    end

    # call-seq:
    #   mutex_stat.update( val ) -> nil
    # 
    # Update the running stats with the new value in a threadsafe manner.
    #
    def update( value )
      @mutex.synchronize do
        super( value )
      end
    end
  end
end


