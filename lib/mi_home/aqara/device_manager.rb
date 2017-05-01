module MiHome
  class DeviceManager
    def initialize(devices_name,log)
      @devices = {}
      @devices_name = devices_name
      @log = log
    end
    def add(device)
      @devices[device.sid] = device
    end
    def remove(device)
      @devices.delete(device.sid)
    end
    def [](sid_or_name)
      device = by_sid(sid_or_name)
      unless device
        by_name(sid_or_name)
      end
      device
    end
    def all
      @devices.values
    end
    def by_type(t)
      @devices.values.select { |device| device.type == t.to_s }
    end
    def by_sid(sid)
      @devices[sid]
    end
    def by_name(name)
      sid = @devices_name[name]
      by_sid(sid) if sid
    end
    def as_json
      @devices.values.map{|device| device.as_json}
    end
    def with(&block)
      instance_eval &block
    end
    def method_missing(name, *args, &block)
      device = self[name]
      unless device
        by_types = by_type(name)
        if by_types.length == 1
          device = by_types.first
        elsif by_types.length == 0
          @log.warn "#{name} is not available. Here is list of available devices:\nBy types:\n#{@devices.values.map{|d| "  devices.#{d.type} # #{d.name}" }.join("\n")} \nBy sids: \n#{@devices.values.map{|d| "  devices['#{d.sid}'] # #{d.name}" }.join("\n")}"
          device = nil
        else
          device = by_types
        end
      end
      device
    end
  end
end


