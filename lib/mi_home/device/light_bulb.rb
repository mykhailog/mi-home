module MiHome
  module Device
    class LightBulb < YeelightDevice
      device_name "Light Bulb"
      device_model :light_bulb
      # Effects:
      # :sudden
      # :smooth

      class ColorModes
        RGB_MODE = 1
        COLOR_TEMPERATURE_MODE = 2
        HSV_MODE = 3
      end
      DEFAULT_EFFECT = :smooth
      DEFAULT_DURATION = 350
      def as_json arg=nil
        {
            id: "#{self.id}",
            device_name: "Yeelight Light Bulb",
            device_model: "light_bulb",
            type: "light_bulb",
            sid: "#{self.id}",
            name: name,
            rgb: rgb.to_i,
            hue: hue.to_i,
            saturation: saturation.to_i,
            power: power,
            temperature: temperature.to_i,
            brightness: brightness.to_i,
            color_mode: color_mode
        }
      end
      def temperature
        get :ct
      end
      def sid
        id
      end
      def id
        @id||=get(:id)
      end
      def power
        get :power
      end

      def on?
        self.power == 'on'
      end

      def off?
        self.power == 'off'
      end

      def rgb
        get :rgb
      end

      def name
        get :name
      end

      def hue
        get :hue
      end

      def saturation
        get :sat
      end

      def color_mode
        get :color_mode
      end

      def flow?
        get(:flowing).to_i == 1
      end

      def flow_params
        get(:flow_params)
      end

      def music_mode?
        get(:music_on).to_i == 1
      end

      def brightness
        get :bright
      end

      def name=(name)
        set :name, [name]
      end

      def temperature= value
        value = value.to_i
        if value < 1700 or value > 6500
          raise "Temperature should be in range of 1700 to 6500"
        end
        set_temperature value
      end

      def rgb= value
        value = value.to_i
        if value < 0 or value > 16777215
          raise "RGB should be in range of 0 to 16777215"
        end
        set_rgb value
      end

      def hue= value
        set_hsv value, saturation
      end

      def saturation= value
        set_hsv hue, value
      end

      def power= value
        set_power value
      end

      def brightness= value
        value = value.to_i
        if sat < 0 or sat >100
          raise "Brighness should be in range of 1 to 100"
        end
        set_brightness value
      end


      def set_brightness value, effect=DEFAULT_EFFECT, duration=DEFAULT_DURATION
        set :bright, [value, effect, duration]
      end

      def set_temperature value, effect=DEFAULT_EFFECT, duration=DEFAULT_DURATION
        set :ct_abx, [value, effect, duration]
      end

      def set_rgb value, effect=DEFAULT_EFFECT, duration=DEFAULT_DURATION
        set :rgb, [value, effect, duration]
      end

      def set_hsv hue, sat, effect=DEFAULT_EFFECT, duration=DEFAULT_DURATION
        hue = hue.to_i
        if hue < 0 or hue > 359
          raise "Hue should be in range of 0 to 359"
        end
        sat = sat.to_i
        if sat < 0 or sat > 100
          raise "Saturation should be in range of 0 to 100"
        end
        set :hsv, [hue, sat, effect, duration]
      end

      def set_power value, effect=DEFAULT_EFFECT, duration=DEFAULT_DURATION
        set :power, [value ? :on : :off, effect, duration]
      end

      def on!
        self.set_power :on, :smooth, 1000
      end

      def off!
        self.set_power :off, :smooth, 1000
      end

      def toggle!
        call :toggle
      end

      # This method is used to save current state of smart LED in persistent memory.
      # So if user powers off and then powers on the smart LED again (hard power reset),
      # the smart LED will show last saved state.
      # Note: The "automatic state saving" must be turn off
      def default!
        call :set_default
      end

      # def start_cf count,action,flow
      #   call_method :start_cf,[count,action,flow],id:9
      # end
      # def stop_cf
      #   call_method :start_cf,id:10
      # end

      # def set_scene
      # def cron_add
      # def cron_del
      # def cron_get
      # def set_adjust
      # def set_music


    end
  end
end
