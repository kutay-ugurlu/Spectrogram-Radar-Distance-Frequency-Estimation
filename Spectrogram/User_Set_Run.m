%% USER SET TESTS
% In this section of the script, the user can modify the code given below
% to create signals of specified parameters, later these signals will be
% summed up and shown in time and spectrogram plots.

% To eliminate a signal, the user should set its amplitude to 0. That
% signal is not going to be shown in the output plots.

F_s = 44.1e3; % Sampling Frequency
total_length = 15; % Total length of the resultant signal in seconds starting from 0

cosine_signal_count = 2;
cosine_amplitudes = [5 10]; % Amplitudes for cosine signals, 1-length vector can be used to set a single cosine 
cosine_frequencies = [1000 5000] ; % Frequencies for cosine signals, 1-length vector can be used to set a single cosine 
cosine_phases = [0 0]; % Phases for cosine signals, 1-length vector can be used to set a single cosine 

square_amplitude = 1; % Amplitude for square wave signal
square_frequency = 1.5e3 ; % Frequency for square wave signal
square_phase = 0; % Phase for square wave signal
square_duty_cycle = 80; % Duty cycle for square wave in percent

sawtooth_amplitude = 1; % Amplitude for sawtooth wave signal
sawtooth_frequency = 2e3 ; % Frequency for sawtooth wave signal
sawtooth_phase = 0; % Phase for sawtooth wave signal
sawtooth_width = 0; % Width for sawtooth wave signal

windowed_s_amplitude = 5; % Amplitude for windowed_s signal
windowed_s_frequency = 1; % Frequency for windowed_s signal
windowed_s_phase = 0; % Phase for windowed_s wave signal
windowed_s_window_name = '@rectwin'; % Window name for windowed_s signal in type string
windowed_s_window_length = 3; % Window length in sample
windowed_s_starting_time = 12;

linear_chirp_amplitude = 1; % Amplitude for linear_chirp signal
linear_chirp_frequency_init = 1; % Frequency init for linear_chirp signal
linear_chirp_phase = 0; % Phase for linear_chirp wave signal
linear_chirp_bandwidth = 5e3; % Bandwidth for linear_chirp signal

%% Set intervals for each signal 

cos_start = 0 ; cos_end = 3;
square_start = 3; square_end = 6;
sawtooth_start = 6; sawtooth_end = 9;
% Windowed_s start and end points are specified with window_length and window_starting_time parameters.
linear_chirp_start = 9; linear_chirp_end = 12;

[Cosines, t_Cosines] = get_multiple(cosine_signal_count,cos_end-cos_start,F_s,cosine_frequencies,cosine_amplitudes,cosine_phases);
[Square, t_Square] = get_square(square_end-square_start,F_s,square_frequency,square_amplitude,square_phase,square_duty_cycle);
[Sawtooth, t_Sawtooth] = get_sawtooth(sawtooth_end-sawtooth_start,F_s,sawtooth_frequency,sawtooth_amplitude,sawtooth_phase,sawtooth_width);
[Windowed_s, t_Windowed_s, ~] = get_windowed_s(windowed_s_window_length,F_s,windowed_s_frequency,windowed_s_amplitude,windowed_s_phase,windowed_s_window_name,0,windowed_s_window_length);
[Linear_chirp, t_Chirp] = get_linear_chirp(linear_chirp_end-linear_chirp_start,F_s,linear_chirp_frequency_init,linear_chirp_amplitude,linear_chirp_phase,linear_chirp_bandwidth,linear_chirp_start);

%% USER_SET signal for demo 

t = 0 : 1/F_s : total_length;

% Multiple Cosines
first_sample = find(t==cos_start);
end_sample = first_sample + F_s * (cos_end-cos_start);
% t_Cosines = [zeros(1,first_sample-1) t_Cosines zeros(1,length(t)-end_sample)] + cos_start;
Cosines = [zeros(1,first_sample-1) Cosines zeros(1,length(t)-end_sample+1)];

% Squares
first_sample = find(t==square_start);
end_sample = first_sample + F_s * (square_end - square_start);
% t_Cosines = [zeros(1,first_sample-1) t_Cosines zeros(1,length(t)-end_sample)] + cos_start;
Square = [zeros(1,first_sample-1) Square zeros(1,length(t)-end_sample+1)];

% Sawtooth
first_sample = find(t==sawtooth_start);
end_sample = first_sample + F_s * (sawtooth_end - sawtooth_start);
% t_Cosines = [zeros(1,first_sample-1) t_Cosines zeros(1,length(t)-end_sample)] + cos_start;
Sawtooth = [zeros(1,first_sample-1) Sawtooth zeros(1,length(t)-end_sample+1)];

% Linear Chirp
first_sample = find(t==linear_chirp_start);
end_sample = first_sample + F_s * (linear_chirp_end-linear_chirp_start);
Linear_chirp = [zeros(1,first_sample-1) Linear_chirp zeros(1,length(t)-end_sample+1)];

% Windowed Sinusoidal 
t_Windowed_s = t_Windowed_s + windowed_s_starting_time;
first_sample = find(t==t_Windowed_s(1));
end_sample = first_sample + F_s * (windowed_s_window_length);
Windowed_s = [zeros(1,first_sample-1) Windowed_s zeros(1,length(t)-end_sample)];


%% DEMO 
% _________________________________________________________________________
% This part is for demo.
Signal = Square+Cosines+Sawtooth+Linear_chirp+Windowed_s;

%% RECORD AUDIO 
% The user can uncomment the below 4 lines of code to record their voice.

% F_s = 44.1e3;
% recObj = audiorecorder(F_s,8,1);
% recordblocking(recObj, total_length);
% Signal = transpose(getaudiodata(recObj));
% t = linspace(0,total_length,F_s*total_length);

%% LOAD AUDIO DATA FROM FILE
% The user can uncomment the below 4 lines of load the audio data from a
% specified file path.

% filename = 'C:\Users\KutayUgurlu\Desktop\sample.mp4';
% [y,F_s] = audioread(filename);
% total_length = length(y)/F_s;
% t = linspace(0,total_length,F_s*total_length);
% Signal = y';

%% VISUALIZATION
figure1 = figure('Position', [500, 60, 1000, 900]); % To adjust figsize
plot([1:length(Signal)]/F_s,Signal);
title({'User Set Aggregated Signal vs Time','(0-3)sec: Cosines with 1kHz and 5kHz','(3-6)sec: Square with 1.5kHz and %80DutyCycle','(6-9)sec: Sawtooth with 2kHz ','(9-12)sec: Linear Chirp with f_{0}=1Hz, m = 5kHz, \Delta = 3 sec'})
xlabel('t (sec)')
ylabel('Amplitude')
grid on 
window_to_signal_length_ratio = 10;
Window = window(@rectwin,ceil(length(Signal)/(window_to_signal_length_ratio)));
Freq_Range = 1.5e2;
STFT = st_ft(F_s,Signal,Window,0.1);
Spectrogram(STFT,F_s,Freq_Range,total_length,'User Set Aggregated Signal');




