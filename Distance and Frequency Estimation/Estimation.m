%% EE430 Project Part 2 
function [estimated_speed, estimated_delay] = Estimation()
%% PARAMS
window_name = '@rectwin';
window = rectwin(200);
F_s = 40e3;
stride_in_sec = 0.025;
signal_amp = 20;
bandwidth_chirp = 5e3;

%% SINE ORIGINAL
[original,t]= get_windowed_s(10,F_s,8e3,signal_amp,0,window_name,0,10);
t_ex = [0:1/F_s:t(1) t];
original = [zeros(1,length(0:1/F_s:t(1))) original];
% subplot(1,3,1)
% plot(t_ex,original)
% title('Transmitted')

%% SINE SHIFTED
[dopp_shift,t]= get_windowed_s(10,F_s,16e3,signal_amp,0,window_name,3,8);
t_ex = [0:1/F_s:t(1) t];
dopp_shift = [zeros(1,length(0:1/F_s:t(1))) dopp_shift];
% 
% % Add noise
% dopp_shift = dopp_shift + (signal_amp/sqrt(100))*randn(1,length(dopp_shift));

% subplot(1,3,2)
% plot(t_ex,dopp_shift);
% title('Received')

%% CHIRP ORIGINAL
% [original,t]= get_linear_chirp(10,F_s,4e3,signal_amp,0,bandwidth_chirp,0);
% t_ex = [0:1/F_s:t(1) t];
% original = [zeros(1,length(0:1/F_s:t(1))) original];
% subplot(1,4,1)
% plot(t_ex,original)
% title('Transmitted')

%% CHIRP SHIFTED
% [dopp_shift,t]= get_linear_chirp(5,F_s,8e3,signal_amp,0,bandwidth_chirp,2);
% t_ex = [0:1/F_s:t(1) t];
% dopp_shift = [zeros(1,length(0:1/F_s:t(1))) dopp_shift];

% subplot(1,4,2)
% plot(t_ex,dopp_shift);
% title('Doppler Shifted')

% 
% Add noise
dopp_shift = dopp_shift + (signal_amp/sqrt(50))*randn(1,length(dopp_shift));
% 
% subplot(1,4,3)
% plot(t_ex,dopp_shift);
% title('Received')


%% Noise Reduction
% Assuming a maximum of 20 dB SNR, we filter the samples whose amplitude is
% at most 1/sqrt(10) of the maximum amplitude, assuming also that we have
% to consider solely the constant amplitude sinusoidal and linear chirp. In
% other words, samples, whose amplitude is less than 1/sqrt(10) of the
% maximum amplitude is going to be regarded as noise.
% 
max_amp = max(dopp_shift);
dopp_shift(abs(dopp_shift)<=max_amp/2)=0;
% subplot(1,4,4)
% plot(t_ex,dopp_shift);
% title('Denoised')

%% Speed Estimation for Sine 
% To find it automatically, we can use the last time portion of the STFT to find the frequency 
% range that contains the maximum power 

STFT_orig = st_ft(F_s ,original', window', stride_in_sec);
STFT_dopp = st_ft(F_s ,dopp_shift', window', stride_in_sec);

last_instance_orig = STFT_orig(:,end);
last_instance_dopp = STFT_dopp(:,end);

max_orig_idx = find(last_instance_orig == max(last_instance_orig));
original_freq = F_s * max_orig_idx / length(last_instance_orig) - 0.5 * F_s;

max_orig_dopp = find(last_instance_dopp == max(last_instance_dopp));
dopp_freq = F_s * max_orig_dopp / length(last_instance_dopp) - 0.5 * F_s;

estimated_speed = 1 - original_freq / dopp_freq

%% Speed Estimation for Linear Chirp 
% To find it automatically, we can use the last time portion of the STFT to find the frequency 
% range that contains the maximum power 

% STFT_orig = st_ft(F_s ,original', window', stride_in_sec);
% STFT_dopp = st_ft(F_s ,dopp_shift', window', stride_in_sec);
% 
% shifted = sum(abs(STFT_dopp));
% shift = shifted(1);
% shifted = shifted - 2*shift;
% first_index_dopp = find(shifted > 0, 1);
% first_instance_dopp = STFT_dopp(:,first_index_dopp);
% first_instance_orig = STFT_orig(:,1);
% 
% 
% max_orig_idx = find(first_instance_orig == max(first_instance_orig));
% original_freq = abs(F_s * max_orig_idx / length(first_instance_orig) - 0.5 * F_s);
% 
% max_orig_dopp = find(first_instance_dopp == max(first_instance_dopp));
% dopp_freq = abs(F_s * max_orig_dopp / length(first_instance_dopp) - 0.5 * F_s);
% 
% 
% 
% estimated_speed = 1 - (original_freq + bandwidth_chirp * 0.2) / dopp_freq;
%% Range Estimation
% Since we have denoised the received signal, especially the portion where we have received no signal due to delay, we utilize these 0 signal region to find the actual delay. 
counter = 1;
L = length(dopp_shift);
while true
    delay = find(dopp_shift,counter);
    if ~(delay(end) == 1) & (dopp_shift(delay(end)-1) == 0) & (delay(end)<L) % & (dopp_shift(delay(end)+1) == 0) 
        counter = counter + 1 ;
    else
        break
    end
end

estimated_delay = delay(end) / F_s;
estimated_range = estimated_delay * 340;

% Spectrogram(STFT_orig,F_s,0.8e3,10,'Linear Chirp_{Original}');
% Spectrogram(STFT_dopp,F_s,0.8e3,10,'Linear Chirp_{dopp}');

end