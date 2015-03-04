require 'vigilem/support/key_map'

require 'vigilem/evdev/system/input'

module Vigilem
module Evdev
module DOM
  # keycode or sym...
  KPTable = Support::KeyMap.new({
    'KP_Space'      => "\u0020",
    'KP_Tab'        => "\u0009",
    'KP_Enter'      => "\u000d",
    'KP_F1'         => "\u0000",
    'KP_F2'         => "\u0000",
    'KP_F3'         => "\u0000",
    'KP_F4'         => "\u0000",
    'KP_Home'       => "\u0000",
    'KP_Left'       => "\u0000",
    'KP_Up'         => "\u0000",
    'KP_Right'      => "\u0000",
    'KP_Down'       => "\u0000",
    'KP_Prior'      => "\u0000",
    'KP_Next'       => "\u0000",
    'KP_End'        => "\u0000",
    'KP_Begin'      => "\u0000",
    'KP_Insert'     => "\u0000",
    'KP_Delete'     => "\u0000",
    'KP_Multiply'   => "\u002a",
    'KP_Add'        => "\u002b",
    'KP_Separator'  => "\u002c",
    'KP_Subtract'   => "\u002d",
    'KP_Decimal'    => "\u002e",
    'KP_Period'     => "\u002e",
    'KP_Divide'     => "\u002f",
    'KP_0'          => "\u0030",
    'KP_1'          => "\u0031",
    'KP_2'          => "\u0032",
    'KP_3'          => "\u0033",
    'KP_4'          => "\u0034",
    'KP_5'          => "\u0035",
    'KP_6'          => "\u0036",
    'KP_7'          => "\u0037",
    'KP_8'          => "\u0038",
    'KP_9'          => "\u0039",
    'KP_Equal'      => "\u003d",
  })
  KPTable.right_side_alias(:char)
  KPTable.left_side_alias(:sym)
  KPTable.left_side_alias(:keysym)
end
end
end
