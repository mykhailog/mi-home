module MiHome
  module Device
    class YeelightDevice < AbstractDevice

      def initialize(host:, port:55443,log:,platform:,id:)
        @transport = MiHome::Yeelight::TcpTransport.new(log:log,host:host,port:port)
        @log = log
        @platform = platform
        @host = host
        @id = id
      end

      protected
      def call  *args
        @transport.call_method *args
      end
      def get  *args
        @transport.get *args
      end
      def set  *args
        @transport.set *args
      end


    end
  end
end
