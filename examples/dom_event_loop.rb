require 'vigilem/evdev/dom'

require 'vigilem/support/core_ext/debug_puts'

Signal.trap("INT") { exit 1 }

devs = Vigilem::Evdev::Device.name_grep(/keyboard/)

adapter = Vigilem::Evdev::DOM::Adapter.new(*devs)

puts 'mash buttons!'

while true
  puts adapter.read_one.inspect
end
