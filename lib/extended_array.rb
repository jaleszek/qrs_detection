	class Array
		def normalize!
			max = self.max
			self.map!{ |f| f/max }
		end

		def square!
			self.map!{ |f| f**2 }
		end

		def begin_with_zeros!(how_much)
			(0...how_much).each{ |f| self[f] = 0.0 }
			self
		end

		def begin_with!(how_much, what)
			(0...how_much).each{ |f| self[f] = what }
			self
		end

		def splot!(indexes, values)
			return nil unless indexes.length == values.length
			indexes.each_with_index{|f, index| self[f] = values[index]}
			self
		end
	end	