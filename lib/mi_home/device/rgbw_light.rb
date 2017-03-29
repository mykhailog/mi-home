module MiHome
  module Device
    class RgbwLight < AqaraDevice
      device_name 'Led Light'
      device_model :rgbw_light

      property :on?, changable:true    #if status: "on"
      property :off?, changable:true   #if status: "off"

      property :level, changable:true
      property :color_temperature, changable:true
      property :x, changable:true
      property :y, changable:true
      property :saturation, changable:true
      property :hue, changable:true
    end
  end
end