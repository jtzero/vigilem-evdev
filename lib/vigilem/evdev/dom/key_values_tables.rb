require 'vigilem/support/key_map'

require 'vigilem/evdev/system'

module Vigilem
module Evdev::DOM
  module KeyValuesTables
    
    include Evdev::System::Input::KeysAndButtons
    
    SpecialKeyValues = Support::KeyMap.new({'Unidentified' => nil })
    ModifierKeys = Support::KeyMap.new.fuse!({
      :'?'              => 'Accel',
      KEY_LEFTALT       => 'Alt',
      KEY_RIGHTALT      => 'Alt'}, {
      :'?'              => 'AltGraph',
      KEY_CAPSLOCK      => 'CapsLock',
      'CtrlL_Lock'      => 'CapsLock',
      KEY_LEFTCTRL      => 'Control',
      KEY_RIGHTCTRL     => 'Control',
      'Control'         => 'Control'}, {
      :'?'              => ['Fn', 'FnLock', 'Hyper'],
      KEY_LEFTMETA      => 'Meta',
      KEY_RIGHTMETA     => 'Meta',
      KEY_NUMLOCK       => 'NumLock',
      KEY_LEFTMETA      => 'OS',
      KEY_SCROLLLOCK    => 'ScrollLock',
      KEY_LEFTSHIFT     => 'Shift',
      KEY_RIGHTSHIFT    => 'Shift'}, {
      :'?'              => ['Super', 'Symbol', 'SymbolLock']
    })
    
    WhitespaceKeys = Support::KeyMap.new({
      KEY_ENTER        => 'Enter',
      'KP_Enter'       => 'Enter',
      :'?'             => 'Separator',
      'Tab'            => 'Tab',
      KEY_TAB          => 'Tab'
    })
    # Space
    
    NavigationKeys = Support::KeyMap.new({
      KEY_DOWN     => 'ArrowDown',
      'Down'       => 'ArrowDown',
      'KP_2'       => 'ArrowDown',
      KEY_LEFT     => 'ArrowLeft',
      'Left'       => 'ArrowLeft',
      'KP_4'       => 'ArrowLeft',
      KEY_RIGHT    => 'ArrowRight',
      'Right'      => 'ArrowRight',
      'KP_6'       => 'ArrowRight',
      KEY_UP       => 'ArrowUp', 
      'Up'         => 'ArrowUp', 
      'KP_8'       => 'ArrowUp', 
      KEY_END      => 'End',
      'KP_1'       => 'End',
      KEY_HOME     => 'Home',
      'KP_7'       => 'Home',
      KEY_PAGEDOWN => 'PageDown',
      'KP_3'       => 'PageDown',
      KEY_PAGEUP   => 'PageUp',
      'KP_9'       => 'PageUp'
    })

    EditingKeys = Support::KeyMap.new.fuse!({
      KEY_BACKSPACE => 'Backspace',
      KEY_CLEAR     => 'Clear', 
      KEY_COPY      => 'Copy', 
      :'?'          => 'CrSel', 
      KEY_CUT       => 'Cut',
      KEY_DELETE    => 'Delete'}, {
      :'?'          => ['EraseEof', 'ExSel'],
      KEY_INSERT    => 'Insert',
      KEY_PASTE     => 'Paste', 
      KEY_REDO      => 'Redo', 
      KEY_UNDO      => 'Undo'
    })
    UIKeys = Support::KeyMap.new.fuse!({
      :'?'        => 'Accept',
      KEY_AGAIN   => 'Again'}, {
      :'?'        => 'Attn',
      KEY_CANCEL  => 'Cancel',
      KEY_COMPOSE => 'ContextMenu',
      KEY_ESC     => 'Escape'}, {
      :'?'        => 'Execute',
      KEY_FIND    => 'Find',
      KEY_HELP    => 'Help',
      KEY_PAUSE   => 'Pause',
      KEY_PLAY    => 'Play',
      KEY_PROPS   => 'Props',
      KEY_SELECT  => 'Select',
      KEY_ZOOMIN  => 'ZoomIn',
      KEY_ZOOMOUT => 'ZoomOut'
    })
    
    DeviceKeys = Support::KeyMap.new.fuse!({
      :'?'                => ['BrightnessDown', 'BrightnessUp'],
      KEY_CAMERA          => 'Camera',
      KEY_EJECTCD         => 'Eject', 
      KEY_EJECTCLOSECD    => 'Eject'}, {
      :'?'                => ['LogOff', 'Power', 'PowerOff'],
      KEY_PRINT           => 'PrintScreen'}, {
      :'?'                => ['Hibernate', 'Standby', 'WakeUp']
    })
    IMEandCompositionKeys = Support::KeyMap.new.fuse!({
      :'?'                         => ['AllCandidates', 'Alphanumeric', 
                                                          'CodeInput'],
      KEY_COMPOSE                  => 'Compose'}, {
      :'?'                         => ['Convert', 'Dead', 'FinalMode', 
                                            'GroupFirst', 'GroupLast'],
      KEY_KBDINPUTASSIST_NEXTGROUP => 'GroupNext',
      KEY_KBDINPUTASSIST_PREVGROUP => 'GroupPrevious',
      KEY_MODE                     => 'ModeChange'}, {
      :'?'                         => ['NextCandidate', 'NonConvert', 
                                        'PreviousCandidate', 'Process', 
                                                      'SingleCandidate']
    })
    KeysspecifictoKoreankeyboards = Support::KeyMap.new.fuse!({
      KEY_HANGEUL => 'HangulMode',
      KEY_HANJA   => 'HanjaMode',
      :'?'        => 'JunjaMode'
    })
    KeysspecifictoJapanesekeyboards = Support::KeyMap.new.fuse!({
      :'?'                  => ['Eisu', 'Hankaku'],
      KEY_HIRAGANA          => 'Hiragana',
      KEY_KATAKANAHIRAGANA  => 'HiraganaKatakana'}, {
      :'?'                  => ['KanaMode', 'KanjiMode'],
      KEY_KATAKANA          => 'Katakana'}, {
      :'?'                  => ['Romaji', 'Zenkaku'],
      KEY_ZENKAKUHANKAKU    => 'ZenkakuHankaku'
    })
    General_PurposeFunctionKeys = Support::KeyMap.new({
      KEY_F1  => 'F1',
      KEY_F2  => 'F2',
      KEY_F3  => 'F3',
      KEY_F4  => 'F4',
      KEY_F5  => 'F5',
      KEY_F6  => 'F6',
      KEY_F7  => 'F7',
      KEY_F8  => 'F8',
      KEY_F9  => 'F9',
      KEY_F10 => 'F10',
      KEY_F11 => 'F11',
      KEY_F12 => 'F12',
      :'?'    => ['Soft1', 'Soft2', 'Soft3', 'Soft4']
    })
    
    MultimediaKeys = Support::KeyMap.new.fuse!({
      KEY_CLOSECD         => 'Close',
      KEY_EJECTCLOSECD    => 'Close', 
      KEY_FORWARDMAIL     => 'MailForward', 
      KEY_REPLY           => 'MailReply', 
      :'?'                => 'MailSend'}, {
      KEY_PLAYPAUSE       => 'MediaPlayPause', 
      :'?'                => 'MediaSelect', #too many option need to test
      KEY_STOPCD          => 'MediaStop', 
      KEY_NEXTSONG        => 'MediaTrackNext', 
      KEY_PREVIOUSSONG    => 'MediaTrackPrevious',
      KEY_NEW             => 'New', 
      KEY_OPEN            => 'Open',
      KEY_PRINT           => 'Print',
      KEY_SAVE            => 'Save',
      KEY_SPELLCHECK      => 'SpellCheck',
      KEY_VOLUMEDOWN      => 'VolumeDown', 
      KEY_VOLUMEUP        => 'VolumeUp',
      KEY_MUTE            => 'VolumeMute'
    })
    
    ApplicationKeys = Support::KeyMap.new({
      KEY_CALC          => 'LaunchCalculator',
      KEY_CALENDAR      => 'LaunchCalendar',
      KEY_MAIL          => 'LaunchMail', 
      KEY_PLAYER        => ['LaunchMediaPlayer', 'LaunchMusicPlayer'],
      KEY_PC            => 'LaunchMyComputer',
      KEY_COFFEE        => 'LaunchScreenSaver', 
      KEY_SPREADSHEET   => 'LaunchSpreadsheet',
      KEY_WWW           => 'LaunchWebBrowser', 
      :'?'              => 'LaunchWebCam', #how's this differ from KEY_CAMERA?
      KEY_WORDPROCESSOR => 'LaunchWordProcessor'
    })
    
    BrowserKeys = Support::KeyMap.new({
      :'?' => ['BrowserBack','BrowserFavorites', 'BrowserForward', 
                'BrowserHome', 'BrowserRefresh', 'BrowserSearch', 
                                                     'BrowserStop']
    })
    
    MediaControllerKeys = Support::KeyMap.new().fuse!({
      :'?'                  => ['AudioBalanceLeft', 'AudioBalanceRight']}, {
      KEY_BASSBOOST         => ['AudioBassBoostDown', 'AudioBassBoostUp'],
      :'?'                  => ['AudioFaderFront', 'AudioFaderRear', 
                                'AudioSurroundModeNext', 'AVRInput', 'AVRPower'],
      KEY_CHANNELDOWN       => 'ChannelDown',
      KEY_CHANNELUP         => 'ChannelUp',
      KEY_RED               => 'ColorF0Red',
      KEY_GREEN             => 'ColorF1Green',
      KEY_YELLOW            => 'ColorF2Yellow',
      KEY_BLUE              => 'ColorF3Blue'}, {
      :'?'                  => ['ColorF4Grey', 'ColorF5Brown', 'ClosedCaptionToggle', 
                                'Dimmer', 'DisplaySwap', 'Exit', 
                                'FavoriteClear0', 'FavoriteClear1', 
                                'FavoriteClear2', 'FavoriteClear3', 
                                'FavoriteRecall0', 'FavoriteRecall1', 
                                'FavoriteRecall2', 'FavoriteRecall3', 
                                'FavoriteStore0', 'FavoriteStore1', 
                                'FavoriteStore2', 'FavoriteStore3', 
                                'Guide', 'GuideNextDay', 'GuidePreviousDay', 
                                'Info',   'InstantReplay', 'Link', 
                                'ListProgram', 'LiveContent', 'Lock', 
                                'MediaApps', 'MediaFastForward', 'MediaLast', 
                                'pMediaPause', 'MediaPlay', 'MediaRecord'],
      KEY_REWIND            =>  'MediaRewind'}, {
      :'?'                  =>  ['MediaSkip', 'NextFavoriteChannel', 
                                'NextUserProfile', 'OnDemand', 'PinPDown', 
                                'PinPMove', 'PinPToggle', 'PinPUp', 
                                'PlaySpeedDown', 'PlaySpeedReset', 
                                'PlaySpeedUp', 'RandomToggle', 'RcLowBattery', 
                                'RecordSpeedNext', 'RfBypass', 
                                'ScanChannelsToggle', 'ScreenModeNext', 
                                'Settings', 'SplitScreenToggle', 'STBInput', 
                                'STBPower', 'Subtitle', 'Teletext', 'TV', 
                                'TVInput', 'TVPower', 'VideoModeNext', 
                                'Wink', 'ZoomToggle', 'BrowserBack', 
                                'BrowserForward', 'ContextMenu', 'Eject', 
                                'End', 'Enter', 'Home', 'MediaPlayPause', 
                                'MediaStop', 'MediaNextTrack', 'MediaPreviousTrack', 
                                'Power', 'VolumeDown', 'VolumeUp', 'VolumeMute']
    })
  end
  
  KeyTable = KeyValuesTables.constants.each_with_object(Support::KeyMap.new) do |table_name, memo| 
    if (key_map = KeyValuesTables.const_get(table_name)).is_a? Hash
      key_map.right_side_alias(:dom_code)
      key_map.right_side_alias(:dom_codes)
      key_map.left_side_alias(:keycode)
      key_map.left_side_alias(:keycodes)
      key_map.left_side_alias(:keysym)
      key_map.left_side_alias(:keysyms)
      memo.merge! key_map
    end
  end
  
  KeyTable.right_side_alias(:dom_code)
  KeyTable.right_side_alias(:dom_codes)
  KeyTable.left_side_alias(:keycode)
  KeyTable.left_side_alias(:keycodes)
end
end
