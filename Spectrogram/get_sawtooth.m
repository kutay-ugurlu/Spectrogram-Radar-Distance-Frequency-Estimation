function [signal, t] = get_sawtooth(total_length, F_s, frequency, amplitude, phase, width)
t = linspace(0,total_length,total_length*F_s);
signal = amplitude * sawtooth(2*pi*frequency*t+phase,width);
end