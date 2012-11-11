module FileUtilities
	def save_each_line(filename, array_with_data)
		file = File.open("../dane/" + filename, "w+")
		array_with_data.each{ |f| file.puts("%.20f\n" % f) }
		file.close
	end

	def get_qrs_indexes_from_db(filename)
		begin
			file = File.open(filename)
			file_content = []
			file.each {|line| file_content << line} 
			file_content.map{ |line| split_and_get_value(line) }
		rescue
			p "Something went wrong"
		end
	end

	private

	def split_and_get_value(line)
		splited_line = line.split(" ")
		splited_line[0]
	end
end
