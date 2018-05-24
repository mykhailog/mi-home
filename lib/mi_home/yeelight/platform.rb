module MiHome
  module Yeelight
    class Platform < AbstractDevicePlatform

      def connect wait_for_devices:true,timeout:5
        ips= Yeelight::TcpTransport.discover(timeout:timeout,log:@log)
        ips.each do |ip|
         @devices.add MiHome::Device::LightBulb.new host:ip[1],log:@log,platform:@platform,id:ip[0]
        end
        return ips.length > 0
      end

      def disconnect
        @devices.clear
      end
      def self.type
        :yeelight
      end

    end
  end
end
