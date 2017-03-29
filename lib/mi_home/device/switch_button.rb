module MiHome
  module Device
    class SwitchButton < AqaraDevice
      device_name 'Switch Button'
      device_model :switch

      event  :click,
             :double_click,
             :long_click_press,
             :long_click_release
      # Not supported yet
      property :voltage
    end
  end
end