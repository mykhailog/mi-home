module MiHome

  class DeviceManager
    attr_accessor :devices

    def initialize(devices_name, log)

      @devices_name = devices_name || {}
      @log = log
      clear
    end

    def by_sid(sid)
      devices[sid]
    end

    def all
      devices.values
    end

    alias_method :by_id, :by_sid

    def clear
      self.devices = {}
    end

    def add(device)
      devices[device.sid] = device
    end

    def remove(device)
      devices.delete(device.sid)
    end

    def [](sid_or_name)
      device = by_sid(sid_or_name)
      unless device
        by_name(sid_or_name)
      end
      device
    end


    def by_type(t)
      all.select { |device| device.type == t.to_s }
    end


    def by_name(name)
      if @devices_name
        sid = @devices_name[name]
        by_sid(sid) if sid
      else
        nil
      end
    end

    def as_json
      values.map { |device| device.as_json }
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
          @log.warn "#{name} is not available. Here is list of available devices:\nBy types:\n#{all.map { |d| "  devices.#{d.type} # #{d.name}" }.join("\n")} \nBy ids: \n#{all.map { |d| "  devices['#{d.id}'] # #{d.name}" }.join("\n")}"
          device = nil
        else
          device = by_types
        end
      end
      device
    end
  end

end


