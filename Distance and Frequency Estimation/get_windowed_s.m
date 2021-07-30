function [signal, t, w] = get_windowed_s(total_length, F_s, frequency, amplitude, phase, window_name, starting_time, window_length)

%Built-in window uses sample number. To convert seconds to sample number we
%must use 
T =  1 / F_s;
t = [0 : T : total_length];
t_w = [starting_time : T : starting_time + window_length];
w = transpose(window(str2func(window_name), window_length*F_s + 1)); %To maintain the given sampling period, needed to consider the outermost samples
signal = amplitude * cos(2*pi*frequency*t + phase);
intersection = intersect(t,t_w);
idx_start_signal = find(t == intersection(1));
idx_end_signal = find(t == intersection(end));
idx_start_window = find(t_w == intersection(1));
idx_end_window = find(t_w == intersection(end));
signal = signal(idx_start_signal:idx_end_signal) .* w(idx_start_window:idx_end_window); 
w = w(idx_start_window:idx_end_window);
t = t(idx_start_signal:idx_end_signal);
end