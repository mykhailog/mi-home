module MiHome
  module Device
    class LightSwitch < AqaraDevice
      device_name 'Light switch'
      device_model :ctrl_neutral1

      property :on?, channel_0: 'on', changable:true
      property :off?, channel_0: 'off', changable:true
      def toggle!
        if on?
          off!
        else
          on!
        end
      end
    end
  end
end

