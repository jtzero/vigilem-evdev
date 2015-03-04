require 'vigilem/support/core_ext'

require 'vigilem/support/key_map'

require 'vigilem/_evdev'

require 'vigilem/evdev/context_filter'

module Vigilem
module Evdev
  # 
  # filters events if the VTY differs from the one of this process
  class VTYContextFilter
    
    KeyMap = Support::KeyMap
    
    include ContextFilter
    # @todo make these class_methods
    attr_reader :current_console_num, :console_keys, 
           :current_console_keys, :other_console_keys
    
    # 
    # @param  [KeyMap] keymap
    # @return 
    def initialize(keymap=Evdev.key_map)
      @key_map = keymap unless keymap.eql? Evdev.key_map
      
      @current_console_num = `fgconsole`.rstrip.to_i
      curr_con_keys, oth_con_keys = 
        self.class.console_keys(keymap).partition {|syms,v| v == "Console_#{@current_console_num}" }
      @current_console_keys, @other_console_keys = KeyMap[curr_con_keys], KeyMap[oth_con_keys]
      
      @current_console_keys.left_side_aliases(:keycode, :keycodes)
      @current_console_keys.right_side_aliases(:keysym, :keysyms)
      
      @other_console_keys.left_side_aliases(:keycode, :keycodes)
      @other_console_keys.right_side_aliases(:keysym, :keysyms)
      
      @current_keys = []
    end
    
    # 
    # @param  [KeyMap] keymap
    # @return [KeyMap]
    def self.console_keys(keymap)
      @console_keys = if keymap.metadata[:loader].class.name =~ /KmapLoader/
          keymap.select {|k,v| v =~ /console_\d+/i }
        else
          console_syms = keymap.info.keysyms.select {|k,v| v =~ /console_\d+/i }
          tmp = keymap.select {|k,v| v =~ /^#{console_syms.keys.join('|')}$/ } 
          tmp.each {|k,v| tmp[k] = console_syms[v] }
        end
    end
    
    # 
    # @return [KeyMap]
    def key_map
      @key_map || Evdev.key_map
    end
    
    # 
    # @return [Array]
    def current_keys
      if @current_keys and current_keys_changed? 
        max_and_one = KeyMap.mod_weights.values.max + 1
        @current_keys.sort_by! {|ksym| KeyMap.mod_weights[ksym.downcase] || max_and_one }
        @current_keys_hash_cache = @current_keys.hash
        @current_keys
      else
        if @current_keys.nil?
          @current_keys = []
          @current_keys_hash_cache = @current_keys.hash
        end
        @current_keys
      end
    end
    
    # 
    # @param  [Array<System::InputEvent>] events
    # @return [Array]
    def process(*events)
      events.select do |event|
        off_status = off?
        key_check = if event.type == System::Input::EV_KEY
          if event.value == 1
            add_key(keysym_or_keycode(event.code))
            off_status
          elsif event.value == 0
            kork = keysym_or_keycode(event.code)
            release_status = allow_release?(kork)
            remove_key(kork)
            release_status
          end
        end
        if key_check.nil? then off_status else key_check end
      end
    end
    
    # 
    # @param  key
    # @return [Array]
    def add_key(keycode_or_keysym)
      current_keys << keycode_or_keysym
    end
    
    # 
    # @param  [Fixnum] key_num
    # @return 
    def remove_key(keycode_or_keysym)
      current_keys.delete(keycode_or_keysym)
    end
    
    # 
    # @todo   name
    # @return [String] 
    def keysym_or_keycode(key_num)
      sym = keysym(keycode = "keycode#{key_num}")
      if sym =~ /shift|alt|c(on)?tro?l|capsshift/i
        sym
      else
        keycode
      end
    end
    
    # @todo   move to KeyMapUtils, or something like that
    # @param  [Integer] key_num
    # @return [String]
    def keysym(keycode)
      if key_map.metadata[:loader].class.name =~ /KmapLoader/
        key_map.keysym(keycode)
      else
        key_map.info.keysyms[key_map.char_ref(keycode)]
      end
    end
    
    # 
    # @return [TrueClass || FalseClass || NilClass]
    def on?
      if changed_vty?
        self.filter_ommisions = current_keys_downcase
        on_change(ON)
      elsif reverted_vty?
        self.filter_ommisions = current_keys_downcase
        on_change(OFF)
      end
      was_on?
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def reverted_vty?
      was_on? and current_console_keys.keysym(current_keys_downcase)
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def changed_vty?
      was_off? and other_console_keys.keysym(current_keys_downcase)
    end
    
    # 
    # @return [TrueClass || FalseClass]
    def off?
      not on?
    end
    
   private
    # 
    # @return [Integer] the hash of current_keys last time it was set
    def current_keys_hash_cache
      @current_keys_hash_cache ||= @current_keys.hash
    end
    
    # 
    # @return [TrueClass || FalseClass] if the cached value of 
    #          #current_keys.hash changed
    def current_keys_changed?
      current_keys_hash_cache != @current_keys.hash
    end
    
    # @todo   name!
    # @return [Array]
    def current_keys_downcase
      downcase_hash ||= 0
      if @current_keys_downcase.nil? or current_keys_hash_cache != downcase_hash
        downcase_hash = current_keys_hash_cache
        @current_keys_downcase = current_keys.map(&:downcase)
      else
        @current_keys_downcase
      end
    end
    
   private
    attr_writer :filter_ommisions
    
    # 
    # @param  other
    # @return [TrueClass || FalseClass]
    def allow_release?(keycode_or_keysym)
      lower_kork = keycode_or_keysym.downcase
      if filter_ommisions.include? lower_kork
        filter_ommisions.delete(lower_kork)
        on?
      else
        off?
      end
    end
    
    # 
    # @return [Array]
    def filter_ommisions
      @filter_ommisions ||= []
    end
  end
end
end
