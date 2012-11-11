module EcgDataReader
	require 'rubygems'
	require 'ruby-debug'
	require 'fileutils'

	def initialize_dcm_data(filepath)
		begin
			FileUtils.cp(filepath, "temporary.dcm")
			sleep(2)
			%x{./a.out}
		rescue
			p "Something went wrong with creating temporary data file"
			nil
		end
	end

	def clean_dcm_data
		begin
			FileUtils.rm("temporary.dcm")
		rescue
			p "Something went wrong with deleting temporary file"
		end
	end

	def iterate_and_process_all_probes(array)
		array.map{ |arr| change_format(arr)}
	end

	private

	def open_ecg_data_file(file_path = "out_data.txt")
		file = File.new(file_path, "r")
		out = []
		while (line = file.gets)
      out << line
    end
    out
	end

	def change_format(formated_number)
	  s_formated_number = formated_number.split("e")
	  if s_formated_number.length.eql?(2)
			s_formated_number[0].to_f*(10**s_formated_number[1].to_i)
		else
			s_formated_number.first.to_f
	  end
	end

	def get_ascii_array(file_path = "out_data.txt")
		ascii_ecg_array = open_ecg_data_file(file_path)
	end
end