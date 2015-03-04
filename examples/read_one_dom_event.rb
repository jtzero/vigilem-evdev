require 'vigilem/evdev/dom'

require 'vigilem/support/core_ext/debug_puts'

devs = Vigilem::Evdev::Device.name_grep(/keyboard/)

adapter = Vigilem::Evdev::DOM::Adapter.new(*devs)

puts 'press a button'

puts adapter.read_one.inspect
