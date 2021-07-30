function [signal, t] = get_square(total_length, F_s, frequency, amplitude, phase, duty_cycle_in_percent)
t = linspace(0,total_length,total_length*F_s);
signal = amplitude * square(2*pi*frequency*t+phase,duty_cycle_in_percent);
end