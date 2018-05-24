module MiHome
  module Device
    class AbstractDevice
      include Unobservable::Support
      attr_accessor :platform,:data,:id

      def self.device_name(name)
        define_method :name do
          name
        end
      end

      def self.device_model(model)
        define_method :model do
          model
        end
      end
      def type
        self.class.name.underscore.split('/')[-1]
      end
    end
  end
end