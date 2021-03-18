%% Load Data
close all
b18lab_pathname=pwd;
data_pathname=[b18lab_pathname, filesep, 'DATA', filesep, 'B18_ECG_data'];
file = 'PhysionetData.mat';
A = load([data_pathname, filesep, file]);

%% Exercise 2 
%% 1. Detrend and standardise
sigN = A.Signals{16};
sigA = A.Signals{4};

sigN = normalize(sigN - mean(sigN));
sigA = normalize(sigA - mean(sigA));

%% 2. Filter
fs = 300;  % Hz
fLow = 100;  % Hz
fHigh = 0.5;  % Hz
order = 4;

sigN_filtered = filter_ecg(sigN, fs, fHigh, fLow, order);
sigA_filtered = filter_ecg(sigA, fs);

%% 3. Plot many things
time = (1:length(sigA_filtered))./fs;
figure('Name','ECG post filter');
subplot(2,2,1);
plot(time, sigN_filtered)
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Normal Rhythm; Recording: A04984')
axis square

subplot(2,2,2);
plot(time, sigA_filtered)
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('AFib Rhythm; Recording: A03605')
axis square

subplot(2,2,3);
range = [find(time==15.47):find(time==18.40)];
plot(time(range), sigN_filtered(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Normal Rhythm; Zoomed in')
axis square

subplot(2,2,4)
range = [find(time==15.47):find(time==18.40)];
plot(time(range), sigA_filtered(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('AFib Rhythm; Zoomed in')
axis square
%% Exercise 3
%% 1. plot PSD estimate 

% normal signal
window = hamming(length(sigN));
[pxxN,fN] = periodogram(sigN, window,[],fs,'psd');

% AFib signal
window = hamming(length(sigA));
[pxxA,fA] = periodogram(sigA, window,[],fs,'psd');

figure('Name','PSD estimate')
subplot(1,2,1)
plot(fN, pxxN);
xlim([0,30]);
title('Normal Rhythm; Recording: A04984')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

subplot(1,2,2)
plot(fA, pxxA);
xlim([0,30]);
title('AFib Rhythm; Recording: A03605')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

%% 2. Welch's PSD
[pxx_pwelchN, f_pwelchN] = pwelch(sigN, [],[],[], fs, 'psd');
[pxx_pwelchA, f_pwelchA] = pwelch(sigA, [],[],[], fs, 'psd');

figure('Name','Welch''s PSD')
subplot(1,2,1)
plot(f_pwelchN, pxx_pwelchN);
xlim([0,30]);
title('Welch''s PSD; Normal Rhythm')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

subplot(1,2,2)
plot(f_pwelchA, pxx_pwelchA);
xlim([0,30]);
title('Welch''s PSD; AFib Rhythm')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

%% Exercise 4
%% I: Determining Heart Rate through R-peak
%% 1. 
MinPeakHeight = 2; MinPeakDistance = 250;
[R_pksN, R_locsN] = findpeaks(sigN, 'MinPeakHeight', MinPeakHeight, 'MinPeakDistance', MinPeakDistance);

MinPeakHeight = 2; MinPeakDistance = 150;
[R_pksA, R_locsA] = findpeaks(sigA, 'MinPeakHeight', MinPeakHeight, 'MinPeakDistance', MinPeakDistance);


figure('Name','R-peaks')
subplot(2,1,1)
plot(time, sigN); hold on;
plot(time(R_locsN), sigN(R_locsN), 'ro');
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Normal Rhythm; Recording: A04984')

subplot(2,1,2)
plot(time, sigA); hold on;
plot(time(R_locsA), sigA(R_locsA), 'ro');
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('AFib Rhythm; Recording: A03605')


%% 2. Mean heart rate
N_mean = length(R_pksN)*2
A_mean = length(R_pksA)*2

%% II: Determining Heart Rate Variability Measures
%% 3. R-R interval times
RR_N = (diff(R_locsN)./fs); % s
RR_A = (diff(R_locsA)./fs); % s



%% 4. Histogram
BinWidth = 20;


figure('Name','R-R Intervals')
subplot(2,2,1)
plot(time(R_locsN(2:end)), RR_N*1000, 'k'); hold on
plot(time(R_locsN(2:end)), RR_N*1000, 'ko')
xlabel('Time (s)')
ylabel('R-R Interval (ms)')
title('RR-intervals; Normal')
axis square

subplot(2,2,2)
histogram(RR_N*1000, 'BinWidth', BinWidth)
xlabel('R-R Interval (ms)')
ylabel('Count')
xlim([400,1200]);
title('Distribution of RR-Intervals; Normal')
axis square

subplot(2,2,3)
plot(time(R_locsA(2:end)), RR_A*1000, 'k'); hold on
plot(time(R_locsA(2:end)), RR_A*1000, 'ko')
xlabel('Time (s)')
ylabel('R-R Interval (ms)')
title('RR-intervals; AFib')
axis square

subplot(2,2,4)
histogram(RR_A*1000, 'BinWidth', BinWidth)
xlabel('R-R Interval (ms)')
ylabel('Count')
xlim([400,1200]);
title('Distribution of RR-Intervals; AFib')
axis square

%% 5. Lomb-Scargle periodogram PSD of RR-intervals
RR_N = RR_N - mean(RR_N);

tN= time(R_locsN(2:end));
tA = time(R_locsA(2:end)); 

f_interest = 0.001:0.001:0.6;

[pxx_plombN, f_plombN] = plomb(RR_N, tN, f_interest, 'psd');
[pxx_plombA, f_plombA] = plomb(RR_A, tA, f_interest, 'psd');
figure('Name', 'Lomb-Scargle')
subplot(1,2,1)
plot(f_plombN, pxx_plombN);
title('Lomb-Scargle PSD Spectrum; Normal')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (s^{2}Hz^{-1})')
axis square

subplot(1,2,2)
plot(f_plombA, pxx_plombA);
title('Lomb-Scargle PSD Spectrum; AFib')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (s^{2}Hz^{-1})')
axis square







