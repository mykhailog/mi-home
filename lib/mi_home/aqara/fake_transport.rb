
require 'json'
require 'securerandom'
module MiHome
  class FakeTransport
    def initialize log
      @log = log
    end
    def connect
      @fake_devices=  AqaraDevice.devices.each {|model,device| [ SecureRandom.hex(10) ,{model:model,device:device}]}.to_h
      @messages =[]
    end
    def send_with_key(message,password:,token:,target:{ip:"127.0.0.1",port:"8080"})

    end
    def send(message,target={ip:MULTICAST_ADDRESS,port:MULTICAST_PORT})
      #  @log.debug 'send %s' % [message.to_json]
      @messages <<  message


    end
    def gateway_sid
      @fake_devices.detect {|k,v|}
    end
    def read
      loop do
        sleep 1
        unless @messages.empty?
          last_message = @messages.pop
          if last_message[:cmd] == "iam"
            message = {cmd: "report",ip: "127.0.0.1",port: "8080",sid: gateway_sid}
            break
          end
          if last_message[:cmd] == "get_id_list"
            message = {cmd: "get_id_list_ack",}
          end
        end

      end
      [message,{ip: "127.0.0.1",port:"8080"}]
    end
  end
end
