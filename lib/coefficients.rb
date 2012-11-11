module Coefficients
	def coeffictients_of_denominator_low_pass_filter
		coefficients, size_of_array = [], 13
		coefficients.begin_with_zeros!(size_of_array)
		coefficients.splot!([0, 6, 12], [1.0, -2.0, 1.0])
	end

	def coefficients_of_numerator_low_pass_filter
		coefficients, size_of_array = [], 13
		coefficients.begin_with_zeros!(size_of_array)
		coefficients.splot!([1,2], [2.0, -1.0])
	end

	def coeffictients_of_denominator_high_pass_filter
		coefficients, size_of_array = [], 33
		coefficients.begin_with_zeros!(size_of_array)
		coefficients.splot!([0, 16, 32], [-1, 32, 1])
  end

	def derivation_coefficients
		[0.25, 0.125, 0.0, -0.125, -0.25]
	end

  def coefficients_of_numerator_high_pass_filter
  	coefficients, size_of_array = [], 33
  	coefficients.begin_with_zeros!(size_of_array)
  	coefficients.splot!([1], [-1])
  end

	def coefficients_of_low_pass_filter
		[coefficients_of_numerator_low_pass_filter, coeffictients_of_denominator_low_pass_filter]
	end

  def coefficients_of_high_pass_filter
  	[coefficients_of_numerator_high_pass_filter, coeffictients_of_denominator_high_pass_filter]
  end
end
