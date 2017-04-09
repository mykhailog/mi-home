
require 'openssl'
require 'unobservable'
require 'active_support/all'
require_relative 'mi_home/version'
require_relative './mi_home/device/aqara_device'
Dir[File.dirname(__FILE__) + '/mi_home/device/*.rb'].each { |file| require file }
require_relative './mi_home/aqara/aqara_platform'
require_relative './mi_home/aqara/device_manager'
require_relative './mi_home/aqara/udp_transport'

module MiHome


end
