module MiHome
  module Device

    class DuplexLightSwitch < AqaraDevice
      device_name 'Duplex Light Switch'
      device_model :ctrl_neutral2

      property(:on?) {|data| data['channel_0'] == 'on' or data['channel_1'] == 'on'
      }
      property(:off?){|data| data['channel_0'] == 'off' or data['channel_1'] == 'off'
      }

      property :light1_on?,channel_0: 'on',
                           changable:true
      property :light2_on?,channel_1: 'on',
                           changable:true
      property :light1_off?,channel_0: 'off',
                           changable:true
      property :light2_off?,channel_1: 'off',
                           changable:true

    end
  end
end