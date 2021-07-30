function [signal, t] = get_linear_chirp(duration, F_s, frequency_init, amplitude, phase, bandwidth, shift)
t = linspace(0,duration,duration*F_s);
t = t + shift; % Assumed user inputs t0 to produce s(t-t0)
signal = amplitude * cos(2*pi*(frequency_init*t + bandwidth/(2*duration)*t.^2) + phase);

end