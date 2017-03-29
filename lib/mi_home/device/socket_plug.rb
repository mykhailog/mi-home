module MiHome
  module Device
    class SocketPlug < AqaraDevice
      device_name 'Socket Plug'
      device_model :plug

      property :on?, changable:true    #if status: "on"
      property :off?, changable:true   #if status: "off"
      property :used?, in_use: '1'

      def toggle!
        if on?
          off!
        else
          on!
        end
      end
      # Not supported yet
      property :load_voltage
      property :load_power
      property :power_consumed
    end
  end
end