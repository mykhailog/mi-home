module MiHome
  class Platform < AbstractDevicePlatform
    class MultiPlatformDeviceManager < DeviceManager
      def initialize platforms
        @platforms = platforms
        @devices = {}
      end

      def by_sid(sid)
        @platforms.each do |platform|
          device = platform.devices[sid]
          return device if device
        end
        return @devices[sid]
      end

      def all
        @platforms.map do |platform|
          platform.devices.all
        end.flatten + @devices.values
      end
    end

    def initialize(configs: {},
                   names: {},
                   log: nil,
                   raise_exceptions: false,
                   debug: false,
                   platforms: [Yeelight::Platform, Aqara::Platform])
      @platforms = platforms.map { |it| it.new(config: configs[it.type], names: names, log: log, raise_exceptions: raise_exceptions, debug: debug) }
      @devices = MultiPlatformDeviceManager.new(@platforms)
      super names: names, log: log, raise_exceptions: raise_exceptions, debug: debug
    end

    def connect
      @platforms.each do |platform|
        unless platform.connect
          @log.warn "Failed to connect to #{platform.class.name} platform"
        end
      end
      if block_given?
        yield
        disconnect
      end
      true
    end

    def disconnect
      @platforms.each do |platform|
        platform.disconnect
      end
    end
  end
end