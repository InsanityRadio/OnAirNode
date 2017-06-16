require 'rubygems'
require 'eventmachine'
require 'securerandom'
require 'digest'

module Server

	attr_reader :nonce
	@@clients ||= []

	def post_init 

		@identifier = self.object_id
		@@clients << self

		send_nonce

	end

	def send_nonce param = ""

		@nonce = SecureRandom.hex(32)
		send_data "#{@nonce}%#{param}\0"

	end

	def receive_data data 

		# nonce\0cmd\0arg\0hmac
		# hmac = sha256(nonce\0cmd\0arg\0secret_key)
		begin

			parts = data[0..-2].split("%")
			calc_nonce = "#{ parts[0..2].join("%") }%#{ $secret }"
			calc_nonce = Digest::SHA256.hexdigest calc_nonce

			raise "Bad nonce" if parts[0] != @nonce
			raise "Bad HMAC" if parts[3] != calc_nonce

			receive_message parts[1], parts[2]

		rescue

			p $!

		end
		send_nonce

	end

	def receive_message type, argument

		puts "Received #{type}, #{argument}"

		case type
		when "sw"
			Glue.switch_to argument.to_i

		end

	end

end