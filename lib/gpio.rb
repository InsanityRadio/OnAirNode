require 'logger'

begin 
	require 'rpi_gpio'
	$mode = 'RaspberryPi'
rescue LoadError
	$mode = 'Dummy'
end


class IO; end

class Dummy < IO

	def initialize index
		@index = index
		@log = Logger.new(STDOUT)
	end

	def on
		@log.info "ON  #{@index}"
	end

	def off
		@log.info "OFF #{@index}"
	end

end

class RaspberryPi < IO

	def initialize index
		
		@index = index
		@pin = [-1, 17, 18, 27][index]
		RPi::GPIO.set_numbering :bcm

		begin
			RPi::GPIO.setup @pin, :as => :output
		rescue
			RPi::GPIO.clean_up
			RPi::GPIO.setup @pin, :as => :output
		end

	end

	def on
		RPi::GPIO.set_high @pin
	end

	def off
		RPi::GPIO.set_low @pin
	end

end

module GPIO

	@sources = [Dummy.new(0)]
	@selected = 0

	(1..3).each { | p | @sources << Object.const_get($mode).new(p) }

	def self.switch_to source_id, tail = 10

		old_selected = @selected
		@selected = source_id
		@sources.each_with_index { | s, p | p == source_id ? s.on : s.off }

		@thread.kill if @thread
		@thread = Thread.new do | t |
			sleep tail
			@sources[old_selected].off unless old_selected == @selected
		end

		File.write("./dat/node_#{$node_id}_last_state", source_id.to_s) rescue nil

	end

end