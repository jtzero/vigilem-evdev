require 'vigilem/core/demultiplexer'

require 'vigilem/core/buffer'

module Vigilem
module Evdev
  # 
  # 
  class Demultiplexer  < Core::Demultiplexer
    
    class << self
      # @todo move away from singleton and look at the one used by x11
      # there should only be one demultiplexer for Evdev
      # @param  [Array<Array<observer_object, Hash{@see #add_observer}>>] observers
      # @return [Demultiplexer]
      def acquire(outputs=[])
        @demultiplexer ||= new(nil, outputs || [])
      end
      
      private :new
      
    end
  end
  
end
end
