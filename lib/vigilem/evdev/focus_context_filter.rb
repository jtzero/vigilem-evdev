require 'vigilem/_evdev'

require 'vigilem/evdev/context_filter'

require 'vigilem/x11/stat'

module Vigilem
module Evdev
  # 
  # allows input_events through when the window has focus
  class FocusContextFilter
    
    include Evdev::ContextFilter
    
    class << self
      
      # 
      # @return [String || NilClass]
      def env_display
        ENV['DISPLAY']
      end
      
      # 
      # 
      def lazy_require
        require 'vigilem/x11/terminal_window_utils'
        require 'vigilem/x11/input_system_handler'
      end
      
      # 
      # @param  [String] display
      # @param  [Integer ||NilClass] xwindow_id
      # @param  [FocusContextFilter || NilClass]
      # @return [NilClass || self]
      def new_if_installed(display=env_display, xwindow_id=nil)
        if X11::Stat.default.installed?
          new(display, xwindow_id)
        end
      end
      
      # 
      # @param  [String] display
      # @param  [Integer || NilClass] xwindow_id
      # @raise  [RuntimeError] 
      # @return [NilClass || self]
      def new_if_installed!(display=env_display, xwindow_id=nil)
        new_if_installed(display, xwindow_id) || raise('InputSystem unavailable')
      end
      
    end
    
    attr_accessor :input_system_handler
    
    def_delegators :input_system_handler, :display, :window_xid
    
    # 
    # @param  [String]
    # @param  [Integer || NilClass]
    def initialize(display=self.class.env_display, xwindow_id=nil)
      self.class.lazy_require
      window_xid = xwindow_id || X11::TerminalWindowUtils.window_id
      
      @input_system_handler = X11::InputSystemHandler.new(window_xid, display, Xlib::FocusChangeMask)
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def has_focus?
      with_focus = X11.get_input_focus(self.display, window_xid)[1]
      with_focus == self.window_xid or
        self.window_xid == X11.query_tree(self.display, with_focus)[:parent_return]
    end
    
    alias_method :had_focus?, :was_off?
    
    # 
    # @return [TrueClass || FalseClass]
    def on?
      if gained_focus?
        on_change(OFF)
      elsif lost_focus?
        on_change(ON)
      end
      was_on?
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def off?
      not on?
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def gained_focus?
      (not had_focus?) and has_focus?
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def lost_focus?
      had_focus? and not has_focus?
    end
    
    # 
    # @param  [Array] events
    # @return [Array]
    def process(*events)
      if on?
        []
      else
        events
      end
    end
    
   private
    # 
    # @param  [TrueClass || FalseClass] bool
    # @return 
    alias_method :had_focus= ,:was_off=
    
  end
end
end
