module MissionsHelper
  def state_amplitude(statevector, index)
    amplitude = statevector.amplitudes[index]
    format_complex(amplitude)
  end

  def format_complex(amplitude)
    format("%.3f %+.3fi", amplitude.real, amplitude.imag)
  end

  def probability_bar(probability)
    "width: #{(probability * 100).round(2)}%"
  end
end
