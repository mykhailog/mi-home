module MiHome
  module Device
    class Motion < AqaraDevice
      device_name 'Motion sensor'
      device_model :motion
      event :motion
      # Not supported yet
      property :voltage
    end
  end
end