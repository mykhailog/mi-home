module MiHome
  module Device
    class ThSensor < AqaraDevice
      device_name 'Temperature And Humidity sensor'
      device_model :sensor_ht

      property(:temperature) {|data| data[:temperature] / 100.0}
      property(:humidity)    {|data| data[:humidity] / 100.0}
    end
  end
end