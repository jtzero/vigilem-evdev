require 'vigilem/support/key_map'

module Vigilem
module Evdev::DOM
  # @todo there are plenty of mappings missing
  # http://www.w3.org/TR/2014/WD-DOM-Level-3-Events-code-20140612/
  module CodeValuesTables
    
    include Evdev::System::Input::KeysAndButtons
    
    code_values = Vigilem::DOM::CodeValues
    
    WritingSystemKeys = Support::KeyMap.new({
      KEY_GRAVE      => 'Backquote',
      KEY_BACKSLASH  => 'Backslash',
      KEY_BACKSPACE  => 'Backspace',
      KEY_LEFTBRACE  => 'BracketLeft',
      KEY_RIGHTBRACE => 'BracketRight',
      KEY_COMMA      => 'Comma',
      KEY_EQUAL      => 'Equal',
      :'?'           => ['IntlBackslash', 'IntlHash'],
      KEY_RO         => 'IntlRo',
      KEY_YEN        => 'IntlYen',
      KEY_MINUS      => 'Minus',
      KEY_DOT        => 'Period',
      KEY_APOSTROPHE => 'Quote',
      KEY_SEMICOLON  => 'Semicolon',
      KEY_SLASH      => 'Slash'
    })
                      
    FunctionalKeys = Support::KeyMap.new({
      KEY_LEFTALT        => 'AltLeft',
      KEY_RIGHTALT       => 'AltRight',
      KEY_CAPSLOCK       => 'CapsLock', 
      KEY_COMPOSE        => 'ContextMenu',
      KEY_LEFTCTRL       => 'ControlLeft',
      KEY_RIGHTCTRL      => 'ControlRight',
      KEY_ENTER          => 'Enter',
      KEY_LEFTMETA       => 'OSLeft',
      KEY_RIGHTMETA      => 'OSRight',
      KEY_LEFTSHIFT      => 'ShiftLeft',
      KEY_RIGHTSHIFT     => 'ShiftRight',
      KEY_SPACE          => 'Space',
      KEY_TAB            => 'Tab',
      :'?'               => ['Convert', 'KanaMode', 'NonConvert'],
      KEY_HANGEUL        => 'Lang1',
      KEY_HANJA          => 'Lang2',
      KEY_KATAKANA       => 'Lang3',
      KEY_HIRAGANA       => 'Lang4',
      KEY_ZENKAKUHANKAKU => 'Lang5'
    })
      
    
    ControlPadSection = Support::KeyMap.new({
      KEY_DELETE   => 'Delete',
      KEY_END      => 'End',
      KEY_HELP     => 'Help',
      KEY_HOME     => 'Home',
      KEY_INSERT   => 'Insert',
      KEY_PAGEDOWN => 'Page Down',
      KEY_PAGEUP   => 'Page Up'
    })
    
    ArrowPadSection = Support::KeyMap[[KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_UP].zip(code_values::ArrowPadSection)]
    
    NumpadSection = Support::KeyMap.new({
      KEY_NUMLOCK    => 'NumLock',
      KEY_KP0        => 'Numpad0',
      KEY_KP1        => 'Numpad1',
      KEY_KP2        => 'Numpad2',
      KEY_KP3        => 'Numpad3',
      KEY_KP4        => 'Numpad4',
      KEY_KP5        => 'Numpad5',
      KEY_KP6        => 'Numpad6',
      KEY_KP7        => 'Numpad7',
      KEY_KP8        => 'Numpad8',
      KEY_KP9        => 'Numpad9',
      KEY_KPPLUS     => 'NumpadAdd',
      KEY_KPDOT      => 'NumpadBackspace',
      :'?'           => ['NumpadClear', 'NumpadClearEntry', 'NumpadComma', 
                          'NumpadEqual', 'NumpadMemoryAdd', 'NumpadMemoryClear', 
                          'NumpadMemoryRecall', 'NumpadMemoryStore', 
                          'NumpadMemorySubtract', 'NumpadParenLeft', 
                                                  'NumpadParenRight'],
      KEY_KPDOT      => 'NumpadDecimal',
      KEY_KPSLASH    => 'NumpadDivide',
      KEY_KPENTER    => 'NumpadEnter',
      KEY_KPASTERISK => 'NumpadMultiply',
      KEY_KPMINUS    => 'NumpadSubtract'
    })
    
    FunctionSection = Support::KeyMap.new({
      KEY_ESC        => 'Escape',
      KEY_F1         => 'F1',
      KEY_F2         => 'F2',
      KEY_F3         => 'F3',
      KEY_F4         => 'F4',
      KEY_F5         => 'F5',
      KEY_F6         => 'F6',
      KEY_F7         => 'F7',
      KEY_F8         => 'F8',
      KEY_F9         => 'F9',
      KEY_F10        => 'F10',
      KEY_F11        => 'F11',
      KEY_F12        => 'F12',
      KEY_FN         => 'Fn',
      :'?'           => 'FLock',
      KEY_PRINT      => 'PrintScreen',
      KEY_SCROLLLOCK => 'ScrollLock',
      KEY_PAUSE      => 'Pause'
    })
    
    MediaKeys = Support::KeyMap.new({ 
      :'?'                 => ['BrowserBack', 'BrowserFavorites', 
                              'BrowserForward', 'BrowserHome', 
                              'BrowserRefresh', 'BrowserSearch', 
                                                    'BrowserStop'],
      [KEY_EJECTCD, 
         KEY_EJECTCLOSECD] => 'Eject',
      KEY_PROG1            => 'LaunchApp1',
      KEY_PROG1            => 'LaunchApp2',
      KEY_EMAIL            => 'LaunchMail',
      KEY_PLAYPAUSE        => 'MediaPlayPause',
      KEY_PROGRAM          => 'MediaSelect',
      KEY_STOPCD           => 'MediaStop',
      KEY_NEXTSONG         => 'MediaTrackNext',
      KEY_PREVIOUSSONG     => 'MediaTrackPrevious',
      KEY_POWER            => 'Power',
      KEY_SLEEP            => 'Sleep',
      KEY_VOLUMEDOWN       => 'VolumeDown',
      KEY_MUTE             => 'VolumeMute',
      KEY_VOLUMEUP         => 'VolumeUp',
      KEY_WAKEUP           => 'WakeUp'
    })
    
    LegacyKeysandNon_StandardKeys = Support::KeyMap.new({
      :'?'         => ['Hyper','Super', 'Turbo', 'Abort', 'Resume'],
      KEY_SUSPEND  => 'Suspend',
      KEY_AGAIN    => 'Again',
      KEY_COPY     => 'Copy',
      KEY_CUT      => 'Cut',
      KEY_FIND     => 'Find',
      KEY_OPEN     => 'Open', 
      KEY_PASTE    => 'Paste',
      KEY_PROPS    => 'Props',
      KEY_SELECT   => 'Select',
      KEY_UNDO     => 'Undo',
      KEY_HIRAGANA => 'Hiragana',
      KEY_KATAKANA => 'Katakana'
    })
    
    Sections = [WritingSystemKeys, FunctionalKeys, ControlPadSection,
                      ArrowPadSection, NumpadSection, FunctionSection,
                              MediaKeys, LegacyKeysandNon_StandardKeys]
    
    def self.add_names(key_map)
      key_map.left_side_alias(:keycode)
      key_map.left_side_alias(:keycodes)
      key_map.right_side_alias(:dom_code)
      key_map.right_side_alias(:dom_codes)
    end
    
    Sections.each {|sec| add_names(sec) }
  end
  
  CodeTable = CodeValuesTables::Sections.each_with_object(Support::KeyMap.new()) do |table, memo|
    memo.merge! table
  end
  
  CodeValuesTables.add_names(CodeTable)
end
end
