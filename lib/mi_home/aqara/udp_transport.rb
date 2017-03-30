require 'ipaddr'
require 'json'

module MiHome
  class UdpTransport
    MULTICAST_ADDRESS = '224.0.0.50'
    MULTICAST_PORT = 4321
    SERVER_PORT = 9898
    AES_IV = [0x17, 0x99, 0x6d, 0x09, 0x3D, 0x28, 0xdd, 0xb3, 0xBA, 0x69, 0x5A, 0x2E, 0x6F, 0x58, 0x56, 0x2e].pack('c*')
    def initialize log
      @log = log
    end
    def connect

      @server_socket = UDPSocket.new
      ip = IPAddr.new(MULTICAST_ADDRESS).hton + IPAddr.new('0.0.0.0').hton
      @server_socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, ip)
      @server_socket.bind(Socket::INADDR_ANY, SERVER_PORT)

    end
    def send_with_key(message,password:,token:,target:{ip:MULTICAST_ADDRESS,port:MULTICAST_PORT})

      cipher =OpenSSL::Cipher::AES.new('128-CBC')
      cipher.encrypt
      cipher.iv = AES_IV
      cipher.key = password
      key = cipher.update(token).unpack('H*')

      raw_data = JSON.parse(message[:data])
      raw_data['key'] = key[0]
      message['data'] = raw_data.to_json
      send message,target
    end
    def send(message,target={ip:MULTICAST_ADDRESS,port:MULTICAST_PORT})
   #  @log.debug 'send %s' % [message.to_json]

      @server_socket.send(message.to_json, 0,target[:ip], target[:port])
    end
    def read
      # puts "before recieve"
      message, rinfo = @server_socket.recvfrom(2048)
      @log.debug message
      #  puts 'recv %s(%d bytes) from client' % [message, message.length]
      begin
        message = JSON.parse(message, object_class: HashWithIndifferentAccess);
      rescue JSON::ParserError => e
        @log.warn "Bad message #{message}"
        message = nil
      end
      [message,{ip: rinfo[2],port:rinfo[1]}]
    end
  end
end
