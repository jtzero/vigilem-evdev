require 'vigilem/evdev/system/input'

module Vigilem
module Evdev
  #/sys/class/input/event1/device/capabilities
  module DeviceCapabilities
    
    def keys?(fd)
      ((_bits >> System::Input::EV_KEY) & 1) == 1
    end
    
    def leds?
      ((_bits >> System::Input::EV_LED) & 1) == 1
    end
    
    def sound?
      ((_bits >> System::Input::EV_SND) & 1) == 1
    end
    
    def relative_axes?
        ((_bits >> System::Input::EV_REL) & 1) == 1
    end
    
    def absolute_axes?
      ((_bits >> System::Input::EV_ABS) & 1) == 1
    end
    
    def misc?
      ((_bits >> System::Input::EV_MSC) & 1) == 1
    end
    
    def switches?
      ((_bits >> System::Input::EV_SW) & 1) == 1
    end
     
    def repeat?
      ((_bits >> System::Input::EV_REP) & 1) == 1
    end
    
    def forcefeedback?
      ((_bits >> System::Input::EV_FF) & 1) == 1
    end
    
    def forcefeedback_status?
      ((_bits >> System::Input::EV_FF_STATUS) & 1) == 1
    end
    
    def power?
      ((_bits >> System::Input::EV_PWR) & 1) == 1
    end
  end
end
end
