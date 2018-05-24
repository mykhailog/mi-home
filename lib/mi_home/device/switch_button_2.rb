module MiHome
  module Device
    class SwitchButton2 < AqaraDevice
      device_name 'Switch Button v2'
      device_model 'sensor_switch.aq2'

      event  :click,
             :double_click,
             :long_click_press,
             :long_click_release
      # Not supported yet
      property :voltage
    end
  end
end