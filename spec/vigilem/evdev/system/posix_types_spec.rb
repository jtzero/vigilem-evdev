require 'spec_helper'

require 'vigilem/evdev/system/posix_types'

describe 'posix_types' do
  it 'defines FFI type __kernel_long_t' do
    expect(FFI::TypeDefs[:__kernel_long_t]).not_to be_nil
  end
  it 'defines FFI type __kernel_time_t' do
    expect(FFI::TypeDefs[:__kernel_time_t]).not_to be_nil
  end
  it 'defines FFI type __kernel_suseconds_t' do
    expect(FFI::TypeDefs[:__kernel_suseconds_t]).not_to be_nil
  end
end
