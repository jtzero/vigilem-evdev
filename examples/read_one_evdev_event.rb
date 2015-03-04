require 'vigilem/evdev/device'

require 'vigilem/evdev/input_system_handler'

devs = Vigilem::Evdev::Device.name_grep(/keyboard/)

handler = Vigilem::Evdev::InputSystemHandler.new(*devs)

puts 'press a button'

puts handler.read_one.inspect
