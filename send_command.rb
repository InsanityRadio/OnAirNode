#!/bin/env ruby
require 'socket'
require 'digest'

$node_id = 0
$secret_key = File.read("/tmp/node_#{$node_id}_secret")

socket = TCPSocket.new "localhost", 9999

nonce = socket.gets("\0").split("%")[0]
message = "#{nonce}%sw%1%"

message += Digest::SHA256.hexdigest "#{message}#{$secret_key}"
message += "\0"

p message

socket << message

p socket.gets "\0"