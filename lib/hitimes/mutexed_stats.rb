require 'hitimes'
require 'thread'

module Hitimes
  #
  # MutexedStats is the start of a threadsafe Stats class.  Currently, on MRI
  # Ruby the Stats object is already threadsafe, so there is no need to use
  # MutexedStats.
  #
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


