function [signal, t] = get_cosine(total_length, F_s, frequency, amplitude, phase)
t = linspace(0,total_length,total_length*F_s);
signal = amplitude * cos(2*pi*frequency*t+phase);
end