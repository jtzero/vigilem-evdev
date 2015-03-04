require 'vigilem/evdev/dom'

Signal.trap("INT") { exit 1 }

devs = Vigilem::Evdev::Device.name_grep(/keyboard/)

adapter = Vigilem::Evdev::DOM::Adapter.new(*devs)

def checkmark
  "\u2713"
end

def ballot_x
  "\u2717"
end

def empty_str_if_false(keyval, pad)
  half = pad / 2
  "#{' ' * half}#{if keyval
    checkmark
  else
    ballot_x
  end}#{' ' * half}"
end

puts 'https://dvcs.w3.org/hg/d4e/raw-file/tip/key-event-test.html'
puts 'mash buttons!'
puts "Event type|shift|ctrl |alt|meta |key                 |code              |location|repeat|data"

while true
  event = adapter.read_one
  puts "#{'%-10s' % event.type}|#{empty_str_if_false(event.shiftKey, 5)}|"\
       "#{empty_str_if_false(event.ctrlKey, 5)}|#{empty_str_if_false(event.altKey, 3)}|"\
       "#{empty_str_if_false(event.metaKey, 5)}|#{'%-20s' % event.key.inspect}|#{'%-18s' % event.code}|"\
       "#{'%-8s' % event.location}|#{'%-6s' % event.repeat}|"
end
