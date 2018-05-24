module MiHome
  module Yeelight
    class TcpTransport
      MULTICAST_HOST = "239.255.255.250"
      MULTICAST_PORT = 1982

      def self.discover timeout:15,log:
        log.info "Discover Yeelight devices..."
        socket = UDPSocket.new(Socket::AF_INET)

        payload = []
        payload << "M-SEARCH * HTTP/1.1\r\n"
        payload << "HOST: #{MULTICAST_HOST}:#{MULTICAST_PORT}\r\n"
        payload << "MAN: \"ssdp:discover\"\r\n"
        payload << "ST: wifi_bulb"

        socket.send(payload.join, 0, MULTICAST_HOST, MULTICAST_PORT)

        devices_info = []
        begin
          Timeout.timeout(timeout) do
            loop do
              devices_info << socket.recvfrom(2048)
              puts devices_info.inspect
             # @log.debug devices_info
              # puts devices_info
            end
          end
        rescue Timeout::Error => ex
          ex

        end
        ips = devices_info.map do |device|
          [device[0].match(/id\: ([xa-f0-9]+)/)[1], device[1][2]]
        end.uniq
        log.info "#{devices_info.length} Yeelight devices found"
        return ips
      end

      def initialize log:, host:, port:
        @log = log
        @host = host
        @port = port
      end

      def request(cmd)
        begin
          s = TCPSocket.open(@host, @port)
          @log.debug "Send command to #{@host}:#{@port}:\n #{cmd.to_json}"
          s.puts cmd.to_json + "\r\n"
          data = JSON.parse(s.gets.chomp)
          s.close
          response(data)
        rescue Exception => msg
          response(JSON.generate({:exception => msg}))
        end
      end

      def response(data)
        # json = JSON.parse(data)
        # create a standard response message
        {
            'status' => data['result'] ? true : false,
            'data' => data
        }
        # JSON.generate(result)
      end

      def call_method method_name, params=[]
        cmd = {id: (method_name.hash.abs % 100).to_s, method: method_name, params: params}
        result = request(cmd)
        if result["data"] and result["data"]["error"]
          raise "An error occurred when execute command #{method_name}. #{result["data"]["error"]["message"]}"
        end

        result["data"]["result"]
      end

      def set(property, params)
        call_method "set_#{property}", params
      end

      def get(property)
        call_method("get_prop", [property])[0]
      end

    end
  end
end