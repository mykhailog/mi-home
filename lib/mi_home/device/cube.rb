module MiHome
  module Device
    class Cube < AqaraDevice
      device_name 'Cube'
      device_model :cube

      event  :flip90,
             :flip180,
             :move,
             :tap_twice,
             :shake_air,
             :swing,
             :alert,
             :free_fall
      property :rotate
      # Not supported yet
      property :voltage
    end
  end
end