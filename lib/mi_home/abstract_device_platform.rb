module MiHome
  class AbstractDevicePlatform
    include Unobservable::Support
    attr_accessor :log, :raise_exceptions
    attr_reader :devices
    attr_event :ready

    def initialize(config: {},
                   names: {},
                   log: nil,
                   raise_exceptions: false,
                   debug: false)
      unless log
        log = Logger.new(STDOUT)
        log.level = debug ? Logger::DEBUG : Logger::INFO
      end
      @log = log
      @raise_exceptions = raise_exceptions
      @devices = DeviceManager.new(names, log) unless @devices
    end

    def join

    end

    # alias_method :loop, :join

    def connect(wait_for_devices: true, timeout: 10)
      fail NotImplementedError, "A device platform class must be able to #connect"
    end

    def disconnect
      fail NotImplementedError, "A device platform class must be able to #disconnect"
    end
  end
end