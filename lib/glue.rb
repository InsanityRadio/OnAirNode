require_relative 'server.rb'
require_relative 'gpio.rb'

module Glue

	def self.switch_to source

		GPIO.switch_to source

	end

end
