require 'extended_array'
require 'file_utilities'
require 'ecg_data_reader'
require 'coefficients'
require 'filtering'
require 'detection_points'

class QRSDetection
	extend FileUtilities
	extend EcgDataReader
	extend Coefficients
	extend Filtering
	extend DetectionPoints

	def self.detect(file_path)
		initialize_dcm_data(file_path)
		# initializating signal
		ecg = iterate_and_process_all_probes(open_ecg_data_file)

		save_each_line("input_ecg_signal.txt", ecg)

		# filtr dolno przepustowy: y(nT) = 2y(nT – T) – y(nT – 2T) + x(nT) – 2x(nT – 6T) + x(nT – 12T) 
		fdp_filtered_signal = infinite_impulse_response(ecg, coefficients_of_low_pass_filter)

		save_each_line("after_fdp_signal.txt", fdp_filtered_signal)

		# filtr górno przepustowy:  y(nT) = x(nT – 16T) – 1/32*  [y(nT – T) + x(nT) – x(nT – 32T)]
		fdp_filtered_signal = infinite_impulse_response(fdp_filtered_signal, coefficients_of_high_pass_filter)
		save_each_line("after_fgp_signal.txt", fdp_filtered_signal)
		# pochodna
		fdd_filtered_signal = finite_impulse_response_filtering(fdp_filtered_signal, derivation_coefficients)
		# square
		fdp_filtered_signal.square!

		save_each_line("after_square_signal.txt", fdp_filtered_signal)

		# moving window integration, N = 20, y(nT) = (1/N)[x(nT - (N - 1)T) + x(nT-(N-2)T) + ... + x(nT)]
		detection_function = moving_window_integration(fdp_filtered_signal)

		# normalization
		detection_function.normalize!

		save_each_line("after_normalization_signal.txt", detection_function)

		save_each_line("detection_function.txt", detection_function)
		potential_points = potential_detection_points(detection_function, 0.015, 32)
		save_each_line("potential_points.txt", potential_points)
		detected_points = detection_points(detection_function, potential_points, 36)
		save_each_line("detected_points.txt", detected_points)

		save_each_line("detected_qrs.txt", detected_points[0..1500])

		clean_dcm_data
	end

	QRSDetection.detect(ARGV.first.to_s)
end
