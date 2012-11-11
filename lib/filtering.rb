require 'rubygems'
require 'ruby-debug'

module Filtering

	def finite_impulse_response_filtering(signal, coefficients)
		temporary_filtered_signal, filtered_signal, index = 0.0, [], 0
		signal_length, coefficients_length = signal.length, coefficients.length

		while index < signal_length
			temporary_filtered_signal = 0.0
			max_value = (index < coefficients_length) ? index : coefficients_length
			index2 = 0
			while index2 < max_value
				# debugger
				temporary_filtered_signal += coefficients[index2]*signal[index - index2]
				index2 += 1
			end
			filtered_signal[index] = temporary_filtered_signal/coefficients_length
			index += 1
		end
		filtered_signal
	end

	def infinite_impulse_response(signal, coefficients)
		coefficients_of_numerator, coefficients_of_denominator = coefficients
		signal_length, coefficients_length = signal.length, coefficients_of_denominator.length
		filtered_signal = []
		(0...signal_length).each{ |i| filtered_signal[i] = 0.0}

		temporary_filtered_signal_value = 0.0
		sample_counter = 0
		while sample_counter < signal_length
			temporary_filtered_signal_value = 0.0
			max_value = (sample_counter < coefficients_length) ? sample_counter : coefficients_length
			filtering_step = 0
			while filtering_step < max_value
				f_c1 = filtered_signal[sample_counter - filtering_step]
				f_c2 = coefficients_of_numerator[filtering_step]
				f_c3 = coefficients_of_denominator[filtering_step]*signal[sample_counter - filtering_step]
				temporary_filtered_signal_value += f_c3 + f_c2 * f_c1
				filtering_step += 1
			end
			filtered_signal[sample_counter] = (temporary_filtered_signal_value/(coefficients_length))
			sample_counter += 1
		end
		filtered_signal
	end

	def moving_window_integration(signal)
		coefficients = []
		coefficients.begin_with!(18, 0.05)
		finite_impulse_response_filtering(signal, coefficients)
	end
end
