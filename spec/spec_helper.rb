event_files = Dir["/dev/input/event*"]

if event_files.empty?
  puts %q<can't find character devices in /dev/input/event*>
  exit
elsif not event_files.any? {|f| File.readable?(f) }
  puts "Your user account isn't allowed to read from /dev/input/event*. please rerun as sudo"
  exit
end

require 'bundler'
Bundler.setup

require 'timeout'

require 'inline'

require 'vigilem/support/core_ext/debug_puts'

require 'vigilem/support/patch/ffi/pointer'

require 'after_each_example_group'

require 'delete_test_cache_after_group'

$ver = `uname -r`.split('-').first

$major = (ary = $ver.split('.')).first.to_i

$minor = ary[1].to_i
