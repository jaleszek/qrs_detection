module DetectionPoints

	def potential_detection_points(detection_function, signal_treshold, window_size) 
		window_shift, local_maximum, index_of_window, eye_closing, detection_function_length = 0, 0, 0, 32, detection_function.length
		potential_detection_points, potential_detection_points_index = [], 0

		potential_detection_points.begin_with!(14400, -1)
		while window_shift <= detection_function_length - window_size
			local_maximum = -1
			index_of_window = window_shift + 1
			while index_of_window < window_shift+window_size-2
				d_f_p0 = detection_function[index_of_window]
				d_f_p1 = detection_function[index_of_window - 1]
				d_f_p2 = detection_function[index_of_window - 2]
				local_maximum = index_of_window - 1 if (d_f_p1 > d_f_p2) && (d_f_p1 > d_f_p0)
				index_of_window += 1
			end
			if (detection_function[local_maximum] > signal_treshold) && (local_maximum >= 0)
				potential_detection_points[potential_detection_points_index] = local_maximum
				window_shift += eye_closing
				potential_detection_points_index += 1
			end
			window_shift += 1
		end
		potential_detection_points.select{ |i| i > 0 }
	end

	def detection_points(detection_function, potential_detection_points, minimum_distance_between_max_points)

		potential_detection_points_number = potential_detection_points.length
		searching_index, setting_index, detected_points = 0, 0, []

		detected_points.begin_with!(potential_detection_points_number, -1)
		window_begin, window_end, sum_of_distances, window_max, window_max_index = 0, 0, 0, 0, 0

		while(searching_index < potential_detection_points_number)

			window_begin = searching_index
			window_end = window_begin

			while(window_end < window_begin+minimum_distance_between_max_points)
				if window_end < potential_detection_points_number - 1 # false tylko w przypadku konczacego sie zakresu, wywolane raz
					difference = potential_detection_points[window_end + 1] - potential_detection_points[window_end]
					sum_of_distances += difference
				end

				if (sum_of_distances > minimum_distance_between_max_points) || (window_end >= potential_detection_points_number - 1) # drugi warunek spelniony raz
					local_maximum = potential_detection_points[window_begin]
					window_max = window_begin+1

					while window_max <= window_end
						reverse = detection_function[potential_detection_points[window_max]] > detection_function[potential_detection_points[window_max - 1]]
						offset = (reverse ? 0 : 1)
						local_maximum = potential_detection_points[window_max - offset]
						window_max += 1
					end

					detected_points[setting_index] = local_maximum
					setting_index +=1
					sum_of_distances, searching_index = 0, window_end
					break

				end
				break if window_end >= potential_detection_points_number - 1
				window_end += 1
			end
			break if window_end >= potential_detection_points_number - 1
			searching_index += 1
		end
		detected_points[0...setting_index]
	end
end