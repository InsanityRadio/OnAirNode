#!/bin/env ruby

require_relative './lib/glue.rb'

$node_id = 0
$secret = "todo"

File.write(path = "/tmp/node_#{$node_id}_secret", "")
File.chmod(0600, path)
File.write(path, $secret)

EventMachine::run do

	EventMachine::start_server "0.0.0.0", 9999, Server

	puts 'Launching'

end