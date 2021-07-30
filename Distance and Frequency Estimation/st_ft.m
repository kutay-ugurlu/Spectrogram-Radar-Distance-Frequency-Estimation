function [STFT, number_of_slices] = st_ft(F_s ,signal, window, stride_in_sec)
window = transpose(window);
window_length_in_sample = length(window);
stride_in_sample = stride_in_sec * F_s;
N  = length(signal);
number_of_slices = ceil((N - window_length_in_sample)/stride_in_sample) + 1; % total number of slides including semi-full one
STFT = zeros(window_length_in_sample, number_of_slices);
for i = 1:number_of_slices-1
    STFT(:,i) = transpose(fftshift(fft(signal((i-1)*stride_in_sample+1:(i-1)*stride_in_sample+window_length_in_sample).*window)));
end
STFT(:,number_of_slices) = transpose(fftshift(fft(signal(end-window_length_in_sample+1:end))));
end
