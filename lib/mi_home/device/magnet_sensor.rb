module MiHome
  module Device
    class MagnetSensor < AqaraDevice
      device_name 'Door/Window Sensor'
      device_model :magnet
      property :open?   # status = "open"
      property :close?  # status = "close"
      # Not supported yet
      property :voltage
    end
  end
end