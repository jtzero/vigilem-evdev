require 'ffi'

FFI.typedef :long, :__kernel_long_t
FFI.typedef :__kernel_long_t, :__kernel_time_t
FFI.typedef :int, :__kernel_suseconds_t
