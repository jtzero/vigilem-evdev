require 'spec_helper'

require 'vigilem/evdev/system/posix_types'

describe 'int' do
  it 'defines __u8' do
    expect(FFI::TypeDefs[:__u8]).not_to be_nil
  end
  
  it 'defines __u8' do
    expect(FFI::TypeDefs[:__u16]).not_to be_nil
  end
  
  it 'defines __u8' do
    expect(FFI::TypeDefs[:__u32]).not_to be_nil
  end
  
  it 'defines __u8' do
    expect(FFI::TypeDefs[:__s8]).not_to be_nil
  end
  
  it 'defines __u8' do
    expect(FFI::TypeDefs[:__s16]).not_to be_nil
  end
  
  it 'defines __u8' do
    expect(FFI::TypeDefs[:__s32]).not_to be_nil
  end
  
end
