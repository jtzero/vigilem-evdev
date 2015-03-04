# Vigilem::Evdev
  Provides DOM conversion and ruby binding for evdev
  
## Installation
  $ gem install vigilem-evdev
  
## Usage
```ruby
  require 'vigilem/evdev/dom'
  
  adapter = Vigilem::Evdev::DOM::Adapter.new
  
  puts adapter.read_one.inspect
```

## tested on
  Linux kernels 3.15, 3.2.0
  ruby 2.0.0 x64 Linux mri
  ruby 2.0.0 x32 Linux mri
  
## Roadmap
 + 1.0.0:
   - @todo's, bug fixes, KeyMap load performance
   - Mac/Bsd
   - mouse
   - jettison 'linux-system' items into own gem
   - less brittel tests
 + next
   - complete ffi items