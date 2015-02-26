# FarmBot Controller

require_relative 'settings.rb'

system('clear')
puts ''

puts '   /\    '
puts '---------'
puts ' FarmBot '
puts '---------'
puts '   \/    '
puts '========='
puts '"q": stop'
require_relative 'lib/status'
$status = Status.new

$shutdown = 0
$db_write_sync = Mutex.new

print 'database        '
require 'active_record'
require_relative 'lib/database/dbaccess'
$bot_dbaccess = DbAccess.new('development')
puts 'OK'

print 'synchronization '
require_relative 'lib/messaging'
puts 'OK'

if $hardware_type != nil
  puts  "hardware        #{$hardware_type}"
  print 'hardware        '
  require_relative 'lib/controller'
  require_relative $hardware_type
  $bot_hardware = HardwareInterface.new(false)
else
  require 'pry'
  $hardware_sim = 1
end
puts 'OK'

puts "uuid            #{$info_uuid}"
puts "token           #{$info_token}"
if $controller_disable == 0
  print 'controller      '
  require_relative 'lib/controller'
  $bot_control  = Controller.new
  $bot_control.runFarmBot
else
  puts 'press key to stop'
  gets.chomp
end
