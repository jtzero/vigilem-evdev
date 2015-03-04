require 'vigilem/evdev/device'

require 'vigilem/evdev/input_system_handler'

Signal.trap("INT") { exit 1 }

devs = Vigilem::Evdev::Device.name_grep(/keyboard/)

handler = Vigilem::Evdev::InputSystemHandler.new(*devs)

def handler.update(obj, status)
  if status == Vigilem::Evdev::ContextFilter::ON
    puts "lost focus"
  else
    puts "got focus"
  end
end

handler.context_filters.each {|cxt| cxt.add_observer(handler) }

puts 'mash buttons!'

while true
  evdev_events = handler.read_many_nonblock(3)
  str = evdev_events.map do |e| 
    if e.type == 1
      sym = Vigilem::Evdev.key_map.keysym("keycode#{e.code}")
      if e.value == 1
        sym
      elsif e.value == 0
        "#{sym} released"
      end
    end
  end.compact.join(',')
  puts str unless str.rstrip.empty?
end
