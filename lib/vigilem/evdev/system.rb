require 'vigilem/core/system'

require 'vigilem/evdev/system/keymap_loaders'

module Vigilem
module Evdev
  # 
  # 
  module System
    include Core::System
    extend Core::System
  end
end
end

require 'vigilem/evdev/system/input'
require 'vigilem/evdev/system/ioctl'
