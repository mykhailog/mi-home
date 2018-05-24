
require 'openssl'
require 'unobservable'
require 'active_support/all'
require_relative 'mi_home/version'
require_relative '../lib/mi_home/device_manager'
require_relative '../lib/mi_home/abstract_device_platform'

require_relative '../lib/mi_home/device/abstract_device'
require_relative '../lib/mi_home/device/yeelight_device'
require_relative './mi_home/device/aqara_device'
Dir[File.dirname(__FILE__) + '/mi_home/device/*.rb'].each { |file| require file }
require_relative './mi_home/aqara/platform'
require_relative './mi_home/compatibility/aqara_platform'
require_relative './mi_home/aqara/udp_transport'
require_relative './mi_home/yeelight/platform'
require_relative '../lib/mi_home/yeelight/tcp_transport'
require_relative '../lib/mi_home/platform'
module MiHome


end
