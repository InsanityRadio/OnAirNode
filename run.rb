#!/bin/env ruby

require_relative './lib/glue.rb'

$node_id = 0
$secret = "todo"

File.write(path = "/tmp/node_#{$node_id}_secret", "")
File.chmod(0600, path)
File.write(path, $secret)

default_or_last = File.read("./dat/node_#{$node_id}_last_state").to_i rescue 1

GPIO.switch_to default_or_last

EventMachine::run do

	EventMachine::start_server "0.0.0.0", 9999, Server

	puts 'Launching'

end