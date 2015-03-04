require 'observer'

require 'forwardable'

module Vigilem
module Evdev
  # 
  # 
  module ContextFilter
    
    # 
    # states of the ContextFilter
    module States
      ON      = 1
      UNKNOWN = nil
      OFF     = 0
    end
    
    include States
    
    # 
    # @return [Hash] 
    def state_hash
      @state_hash ||= States.constants.each_with_object({}) do |const, memo| 
                        memo[States.const_get(const)] = const
                      end
    end
    
    include Observable
    
    # 
    # 
    def self.included(base)
      base.extend Forwardable
    end
    
    attr_reader :last_known_state
    
    # 
    # @return [TrueClass || FalseClass]
    def was_on?
      last_known_state == ON
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def was_off?
      last_known_state.nil? || last_known_state == OFF
    end
    
    # 
    # @raise  [NotImplementedError]
    def on?
      raise NotImplementedError, '#on?, not overriden'
    end
    
    alias_method :filtered?, :on?
    
    # 
    # @raise  [NotImplementedError]
    def off?
      raise NotImplementedError, '#off?, not overriden'
    end
    
    # 
    # @param  [Fixnum<1 || 0>] state
    # @return 
    def on_change(state)
      self.last_known_state = state
      changed
      notify_observers(self, state)
    end
    
   private
    attr_writer :last_known_state
    
    # 
    # @param  [TrueClass || FalseClass] bool
    # @return [Fixnum<1 || 0>]
    def was_on=(bool)
      self.last_known_state= if bool then ON else OFF end
    end
    
    # 
    # @param  [TrueClass || FalseClass] bool
    # @return [Fixnum<1 || 0>]
    def was_off=(bool)
      self.was_on=!bool
    end
  end
end
end
