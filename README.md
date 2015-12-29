# Vigilem::Evdev
  Provides DOM conversion and ruby binding for evdev
  
## Installation
  $ gem install vigilem-evdev  
  (for Bundler see known issues)
  
## Usage
```ruby
  require 'vigilem/evdev/dom'
  
  adapter = Vigilem::Evdev::DOM::Adapter.new
  
  puts adapter.read_one.inspect
```

## rbenv, rvm
  - due to the nature of evdev, sudo is required
  - rvm: comes with sudo
  - rbenv: install https://github.com/dcarley/rbenv-sudo

## tested on
  Linux kernels 3.15, 3.2.0
  ruby 2.0.0 x64 Linux mri
  ruby 2.0.0 x32 Linux mri

### Known issues

#### !!Permissions!!
  In order to run this you will need permission to read from `/dev/input/*`
  Rather than rewrite the wheel, please see 
  https://github.com/jteeuwen/evdev/blob/master/README.md#permissions
  which has a great explanation

### bundler/gem install fail
  Adding just ```gem 'vigilem-evdev'``` is different than ```gem install vigilem-evdev```
  In both cases the vigilem-evdev gem installs it's input_system dependencies on install, however since 
  bundler tracks it's installed gems the dynamically installed gems get added to the $GEM_HOME still, 
  but not added to Gemfile.lock. So in order exactly model production the 'vigilem-x11' needs to be added 
  ```
  gem 'vigilem-evdev'
  gem 'vigilem-x11'
  ```
  @see focus_context_filter.rb and input_system_handler.rb

## FAQ
  + why does vigilem-evdev require vigilem-x11-stat?:  
      + This is convenience for gnome-terminal so that it:  
        - doesn't read the keyboard when the window doesn't have focus
        - this matches how win32 does things and makes it more cross platform

## Roadmap
 + 1.0.0:
   - @todo's, bug fixes, KeyMap load performance
   - Mac/Bsd
   - mouse
   - jettison 'linux-system' items into own gem
   - less brittle tests
 + next
   - complete ffi items
