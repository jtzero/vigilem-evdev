require 'vigilem/dom'

require 'vigilem/core/lockable_pipeline_component'

require 'vigilem/_evdev'

require 'vigilem/evdev/system'

require 'vigilem/evdev/system/input'

require 'vigilem/evdev/dom/input_event_utils'

require 'vigilem/evdev/system/keymap_loaders'

require 'vigilem/evdev/dom/code_values_tables'
require 'vigilem/evdev/dom/key_values_tables'
require 'vigilem/evdev/dom/kp_table'

module Vigilem
module Evdev
module DOM
  # @todo  fix charsets, printable characters, etc, split up KeyTables
  # @todo  fixme REFACTOR!
  module InputEventConverter
    
    KEYCODES = System::Input::KeysAndButtons.constants.each_with_object({}) do |const, hsh| 
                  hsh[System::Input.const_get(const)] = const
                end
    
    PRINTABLE_CHARS = [0x0008..0x000a, 0x0020..0x00ff]
    
    UNKNOWN_VAL = 'Unidentified'
    
    include CodeValuesTables
    include KeyValuesTables
    
    include Core::LockablePipelineComponent
    
    include InputEventUtils
    
    attr_writer :current_keys, :key_map
    
    private :current_keys=
    
    KeymapLoaders = System::KeymapLoaders
    
    # 
    # @return [NilClass]
    def initialize_input_event_converter
      key_map
      nil
    end
    
    # 
    # @return [KeyMap]
    def key_map
      Evdev.key_map
    end
    
    # 
    # @return [Array]
    def current_keys
      @current_keys ||= []
    end
    
    # gets the current modifier keys
    # @todo   capsshift
    # @return [Array<Array<String, String>>] [['ctrl', 'r']]
    def current_mod_keys_w_loc
      current_keys.map do |event|
        if (key = event.key) =~ /c(on)?tro?l|alt|shift/i and
                                              event.type == 'keydown'
          loc = to_dom_location_common_str(event.location)
          [key.gsub('control', 'ctrl').downcase, loc.downcase]
        end
      end.compact
    end
    
    # gets the current modifier keys
    # @return [Array<String>] i.e. ['ctrl']
    def current_mod_keys
      current_mod_keys_w_loc.map(&:first)
    end
    
    # grabs the current modifier keys and adds the location 
    # to the end
    # @return [Array<String>] i.e. ['ctrlr']
    def current_mod_keys_keymap_fmt
      current_mod_keys_w_loc.map do |mod_w_loc| 
        Support::KeyMap.mod_weights.keys & [mod_w_loc.first, mod_w_loc.join]
      end.compact.flatten.uniq.sort {|a,b| Support::KeyMap.mod_weights[a] <=> Support::KeyMap.mod_weights[b] }
      # ruby 2.0.0p384 (2014-01-12) [x86_64-linux-gnu] irb(main):006:0> [1,2,3,4].sort {|a| a } => [4, 3, 1, 2]
    end
    
    # gets the keysyms for the given keycode string and current mod keys
    # @param  [String] keycode_str, i.e. "keycode30"
    # @return [Array<String> || String] the keysyms and (uni|hex)codes
    def keysyms(keycode_str)
      key_map.keysyms(Support::Utils.unwrap_ary([current_mod_keys_keymap_fmt, keycode_str].flatten))
    end
    
    def keysyms!(keycode_str)
      key_map.keysyms(Support::Utils.unwrap_ary(keycode_str))
    end
    
    # gets the DOM::KeyEvent#type from InputEvent#value and
    # Dom::KeyEvent#key
    # @param  [Integer] event_value, InputEvent#value
    # @param  [String] dom_key_value, DOM::KeyEvent#key
    # @return [Array<String> || NilClass] the type of event based on 
    #                                     the given args
    def dom_type(event_value, dom_key_value)
      synchronize {
        type = dom_types[event_value]
        if dom_key_value.unpack('U*').size > 1
          type.take(1)
        else
          type
        end
      }
    end
    
    # 
    # @return [Hash]
    def dom_types
      @dom_types ||= { 0 => ['keyup'], 1 => (down_press = %w(keydown keypress)), 2 => down_press }
    end
    
    # takes a code from an input_event and returns a String
    # representing a DOM::KeyEvent#key
    # @todo   refactor
    # @param  [Integer] event_code, InputEvent#code
    # @return [String] the representing DOM::KeyEvent#key
    def dom_key(event_code, led_names)
      # use infocmp?, terminfo
      synchronize {
        keycode_str = InputEventUtils.event_code_to_keycode_str(event_code)
        
        # raise if this is nil?, char_ref will error if char_code.nil?
        code_or_sym = [*keysyms(keycode_str)].last
        
        char_code, sym = if char_ref?(code_or_sym)
          [code_or_sym, key_map.info.keysyms[code_or_sym]]
        else
          [key_map.info.char_refs[code_or_sym], code_or_sym]
        end
        
        char = char_ref(char_code)
        
        white_space_key = (WhitespaceKeys.keysyms.include?(event_code) or
                                    WhitespaceKeys.keysyms.include?(sym))
        
        if char and not white_space_key
          if char.respond_to?(:upcase) and
                  led_names.include?(:LED_CAPSL) and 
                                           keysyms.grep(/shift/).empty?
            return char.upcase
          else
            return char
          end
        elsif char_ref?(char_code) and (no_mods = [*keysyms!(keycode_str)].last)
          if char = char_ref(no_mods)
            return char
          end
        end
        
        if (not white_space_key) and 
             led_names.include?(:LED_NUML) and (kpkey = KPTable.char(sym))
          kpkey
        elsif (key = KeyTable.dom_codes(sym)) and not key.is_a? Array
          key
        elsif keyfrom_event = KeyTable.dom_codes(event_code) and
                                          not keyfrom_event.is_a? Array
          keyfrom_event
        else
          UNKNOWN_VAL
        end
      }
    end
    
    # 
    # 
    def printable_char?(hex_char)
      Support::Utils.in_ranged_array?(PRINTABLE_CHARS, hex_char)
    end
    
    # 
    # @return [NilClass || Fixnum]
    def char_ref?(str)
      str =~ /^\+?U\+|0x0[\dA-z]+/i # unicode or hex_string
    end
    
    # @todo   fixme!
    # @param  [String] str
    # @return 
    def char_ref(str)
      #"%c" % char
      hex_dec = str.gsub(/\+?U\+/i, '').hex
      if str =~ /^\+?U\+/ # unicode
        hex_dec.chr('UTF-8')
      elsif printable_char?(hex_dec)
        hex_dec.chr('iso-8859-1') # default dumpkeys encoding
      end
    end
    
    # gets the DOM::KeyEvent#code fromm a keycode anem and 
    # a DOMLLKeyEvent#key
    # @todo   needs to be more strict
    # @todo   items modified shift still returns the code for 
    #         the unshifted 
    # @param  [Fixnum] event_code
    # @param  [String] dom_key, DOM::KeyEvent#key
    # @return [String] DOM::KeyEvent#code
    def dom_code(event_code, dom_key_value)
      keycode_name = KEYCODES[event_code]
      
      ret_code = if dom_key_value =~ /^[a-z]$/i
        "Key#{dom_key_value.upcase}"
      elsif dom_key_value =~ /^[0-9]$/
        if keycode_name =~ /^KEY_KP/
          "Numpad#{dom_key_value}"
        else
          "Digit#{dom_key_value}"
        end
      elsif not (codes = [*CodeTable.dom_codes(event_code)]).empty?
        Support::Utils.unwrap_ary(codes)
      elsif dom_key_value != UNKNOWN_VAL
        "#{dom_key_value}#{InputEventUtils.location_str_from_keycode_name(keycode_name)}"
      end
      
      ret_code ||= UNKNOWN_VAL
    end
    
    # gets the DOM_KEY_LOCATION_* of the keycode
    # @param  [String || Symbol] keycode_name
    # @return [Integer] dom location, DOM::KeyEvent::KeyLocations
    def dom_location(keycode_name)
      ::VDOM::Utils.common_str_to_dom_location(
        keycode_name.to_s.gsub(/(KEY_)?((KP)|(R)IGHT|(L)EFT)(.*)/, '\3\4\5')
      )
    end
    
    # creates a SharedKeyboardAndMouseEventInit from #current_mod_keys
    # and a passed in keycode_name
    # @param  [String ||Symbol] keycode_name, KEY_RIGHTCTRL
    # @return [Array<symbol>]
    def dom_modifiers(keycode_name)
      ::VDOM::KeyboardEvent::shared_keyboard_and_mouse_event_init(
        current_mod_keys +
          [keycode_name.to_s.gsub(/(KEY_)?(RIGHT|LEFT)?/i, '').downcase.to_sym]
      )
    end
    
    # takes the InputEvent and returns a representing DOM::KeyEvent
    # @todo   refactor
    # @param  [InputEvent] input_event
    # @return [Array<DOM::KeyEvent>]
    def to_dom_key_event(input_event)
      synchronize {
        
        event_code = input_event.code
        keycode_name = KEYCODES[event_code]
        
        options = {:location => loc = dom_location(keycode_name), 
                   :os_specific => os_spec = ::FFIUtils.struct_to_h(input_event),
                   :repeat => repeat?(os_spec, loc), 
                   :modifiers => dom_modifiers(keycode_name), 
                    }
        
        remove_from_current_keys(options[:os_specific], options[:location])
        
        options[:key] = key = dom_key(event_code, leds(input_event.leds))
        options[:code] = dom_code(event_code, key)
        
        type = dom_type(input_event.value, key)
        
        if type.first != 'keyup'
          key_event = ::VDOM::KeyboardEvent.new(type.first, options)
          
          key_press = type[1] ? [key_event.copy_to(type[1])] : []
          key_down_events = ([key_event] + key_press)
          current_keys.concat(key_down_events)
          key_down_events
        else
          
          key_event = ::VDOM::KeyboardEvent.new(type.first, options)
          
          [*key_event].flatten
        end
      }
    end
    
    # 
    # @param  [Hash] os_specific
    # @param  [Fixnum] dom_location
    # @return [Array || NilClass]
    def remove_from_current_keys(os_specific, dom_location)
      current_keys.reject! do |current|
        current.os_specific.except(:time, :value) == os_specific.except(:time, :value) and 
          current.location == dom_location
      end
    end
    
    # 
    # @param  [Hash] os_specific
    # @param  [Fixnum] dom_location
    # @return [TrueClass || FalseClass]
    def repeat?(os_specific, dom_location)
      !!current_keys.find do |current|
        current.os_specific.except(:time) == os_specific.except(:time) and 
          current.location == dom_location
      end
    end
    
    # 
    # @param  [String]
    # @return [Array<Symbol> || NilClass]
    def leds(bits_str)
      if bits_str
        System::Input::LEDs.constants.select do |const|
          bits_str[System::Input::LEDs.const_get(const)].to_i > 0
        end
      end
    end
    
  end
end
end
end
