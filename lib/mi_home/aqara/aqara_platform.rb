require 'logger'
module MiHome
  class AqaraPlatform

    include Unobservable::Support
    attr_accessor :log,:raise_exceptions
    attr_event :ready

    def initialize(password: nil,
                   log: nil,
                   update_device_interval: 30 * 60,
                   names: {},
                   raise_exceptions:false,
                   debug:false)
      @password = password
      unless log
        log = Logger.new(STDOUT)
        log.level = debug ? Logger::DEBUG : Logger::INFO
      end
      @log = log

      unless password
        log.warn "Password is not specified. You can't do any write functionality (e.g. turn on lights)."
      end
      @devices = DeviceManager.new(names,log)
      @unknown_devices = nil
      @state = :init
      @update_device_list_interval = update_device_interval
      @raise_exceptions = raise_exceptions
    end

    def connect(wait_for_devices: true, timeout: 10)
      listen
      if wait_for_devices
        found_devices = self.wait_for_devices timeout: timeout
        return false unless found_devices
      end
      if block_given?
        yield
        disconnect
      end
      return true
    end

    def disconnect
      if @update_device_list_thread and @update_device_list_thread
        @transport.close
        @message_thread.terminate
        @update_device_list_thread.terminate
        true
      else
        false
      end
    end

    def wait_for_devices timeout:5
      tries = 3
      Timeout::timeout(timeout) do
        loop do
          break if @state == :ready
          sleep 0.05
        end
      end
      return true
    rescue TimeoutError => e
      tries -= 1
      if tries ==0
        error "No devices found. Maybe gateway is not turned on?"
        return false
      else
        @log.warn "Can't get device list. Try again #{tries}/3"
        request_update_device_list
        retry
      end
    end

    def devices
      @devices
    end
    def join
      @message_thread.join
    end

    def __set_current_status(device, data)
      unless device.gateway.password
        error no_password_message( device.gateway.sid)
      end
      @transport.send_with_key({cmd: 'write', sid: device.sid, data: data.to_json},
                               password: device.gateway.password,
                               token: device.gateway.token,
                               target: {ip: device.gateway.ip, port: device.gateway.port})
    end

    def __request_current_status(sid, gateway)
      @transport.send({cmd: 'read', sid: sid}, {ip: gateway.ip, port: gateway.port})
    end

    protected
    def update_device_list_loop
      @update_device_list_thread = Thread.new do
        loop do
          request_update_device_list
          sleep @update_device_list_interval
        end
      end
      @update_device_list_thread.abort_on_exception = true
    end

    def listen
      @log.info "Connect to Aqara gateway..."
      @transport = UdpTransport.new(@log)
      @transport.connect

      @log.info "Listen gateway commands..."
      @message_thread = Thread.new do
        loop do
          self.process_message(*@transport.read)
        end
      end
      @message_thread.abort_on_exception = true
      update_device_list_loop
    end

    def process_message(message, rinfo)
      command = message[:cmd]
      case command
        when 'iam'
          @transport.send({cmd: 'get_id_list'}, {port: message[:port], ip: message[:ip]})
        when 'get_id_list_ack'
          @unknown_devices={}
          gateway = find_or_create_device(model: :gateway, sid: message[:sid])
          unless gateway.token
            gateway.token = message[:token]
            gateway.ip = rinfo[:ip]
            gateway.port = rinfo[:port]
            unless @password.nil?
              if @password.is_a? Hash
                gateway.password = @password[message[:sid]]
                if gateway.password.nil?
                  @log.warn(no_password_message(message[:sid]))
                end
              else
                gateway.password = @password
              end
            end
          end

          data = [message[:sid]] + JSON.parse(message['data']) # add gateway manually
          log.info "Found #{data.length} aqara devices"
          data.each do |device_sid|
            unless @devices[device_sid]
              @unknown_devices[device_sid] = gateway
            end
            __request_current_status device_sid, gateway
          end
        when 'read_ack', 'heartbeat', 'report', 'write_ack'
          device = find_or_create_device(model: message[:model], sid: message[:sid])
          if @unknown_devices
            unless device.gateway
              device.gateway = @unknown_devices.delete(message[:sid])
            end
          end
          device.process_message(message)
          if @state == :init
            unless @unknown_devices.nil?
              if @unknown_devices.empty?
                @state = :ready
                @log.info "Device list updated.\nAvailable devices:\n#{@devices.all.map { |device| "   * #{device.name}\t#{device.type}\t#{device.sid}" }.join("\n")}"
                raise_event :ready
              end
            end
          end
        else
          @log.warn "Unsupported #{command}. Can't process: #{message.to_json}"
      end
    end
    def request_update_device_list
      @log.info "Update device list..."
      @transport.send({cmd: 'whois'})
    end
    def no_password_message sid
      "Can't find password for #{sid}. Please update password init to \n #{@password.dup.merge({sid => '<gateway password>'}).inspect}"
    end
    def error message
      if @raise_exceptions
        raise message
      else
        @log.error message
      end
    end
    def find_or_create_device(model:, sid:)
      device = @devices[sid]
      unless device
        device = MiHome::Device::AqaraDevice.create(model)
        device.sid = sid
        device.platform = self
        @devices.add device
      end
      @devices[sid]
    end
  end
end
