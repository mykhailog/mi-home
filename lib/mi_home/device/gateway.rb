module MiHome
  module Device
    class Gateway < AqaraDevice
      device_name 'Gateway'
      device_model :gateway
      attr_accessor :ip,
                    :port,
                    :password,
                    :token

      property :off?, rgb: '0'
      property(:on?)  {|data| (not data[:rgb].nil? and data[:rgb] != '0')}
      property :rgb, changable:true
      property :illumination, changable:true
      property :mid,changable:true
      def gateway
        self
      end
    end
  end
end