lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vigilem/evdev/system/keymap_loaders'

Vigilem::Evdev::System::KeymapLoaders.build_cache