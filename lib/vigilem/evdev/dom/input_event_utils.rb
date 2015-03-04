module Vigilem
module Evdev
module DOM
  # 
  module InputEventUtils
    
    include Vigilem::DOM::Utils
    
    # takes a InputEvent#code and returns a String
    # representing the keycode value
    # @param  [Integer] event_code, the number to convert
    # @return [String] i.e. "keycode30"
    def event_code_to_keycode_str(event_code)
      "keycode#{event_code}"
    end
    
    # takes a keycode_name and returns a common location string
    # if available
    # @param  [String || Symbol] keycode_name, i.e. KEY_RIGTHCTRL
    # @return [String || NilClass] a common locaiton string i.e. 'Right'
    def location_str_from_keycode_name(keycode_name)
      if loc = keycode_name.to_s.gsub('KP', 'NUMPAD').scan(/LEFT|RIGHT|NUMPAD/i).first
        loc.downcase.tap {|obj| obj[0] = obj[0].upcase }
      end
    end
    
    # takes a keycode name and returns the keymap modifier name
    # @todo  meta
    # @param [String ||Symbol] keycode_name, i.e. KEY_RIGHTCTRL
    # @return [String] keymap_name of the modifier
    def modifier_keymap_name(keycode_name)
      if (keycode_name) =~ /caps|shift|alt|c(on)?tro?l/i
        if keycode_name == :KEY_CAPSLOCK
          'capsshift'
        else
          keycode_name.to_s.gsub(/KEY_/, '').split(/ight|eft/i).reverse.join.downcase
        end
      end
    end
    
    extend self
    
    extend Support::Utils
    
  end
end
end
end
