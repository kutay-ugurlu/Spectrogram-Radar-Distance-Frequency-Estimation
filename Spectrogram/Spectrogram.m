%% SPECTROGRAM

function [spectrogram, number_of_slices, number_of_freq_boxes] = Spectrogram(STFT, F_s, freq_range, total_length, signal_name)

[N, number_of_slices] = size(STFT);
number_of_freq_boxes = ceil((F_s)/freq_range);
spectrogram = zeros(number_of_freq_boxes,number_of_slices);
f = (F_s / N) * linspace(-N/2, N/2, N) + F_s / 2; % [-F_s / 2 : N : F_s / 2]

idx = 1:N;
for i = 1:number_of_slices
    spectrum = transpose(STFT(:,i));
    for j = 1:number_of_freq_boxes
        idx_of_interest = idx( f > (j-1)*freq_range & f < j*freq_range); 
        spectrogram(j,i) = 20*log10(sum(abs(spectrum(idx_of_interest)).^2));
    end
end

% To show the positive spectrum on the heatmap(i.e. spectrogram), just
% truncate some rows out of STFT. This is just for aesthetic purpose. 

figure('Position', [500, 60, 1000, 900]); % To adjust figsize
f = flip(linspace(-F_s/2,F_s/2,number_of_freq_boxes));
xvalues = num2cell(linspace(0,total_length,number_of_slices));
yvalues = num2cell(f/1e3);

h = heatmap(xvalues,yvalues,spectrogram,'colormap',hot);
h.Title = ['Spectrogram of the ',signal_name];
h.YLabel = ['Frequency in kHz'];
h.XLabel = ['t(sec)'];

for i = 1:length(f)
    if mod(i,5) ~= 0
        f(i) = " ";
    end
end
h.YDisplayLabels = f/1e3;

end