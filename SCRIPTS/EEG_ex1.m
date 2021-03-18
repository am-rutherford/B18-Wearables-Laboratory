%% Loading Data
Open = load('C:\Users\Alex\iCloudDrive\Documents\Ox Year 3\B18\B18-Wearables-Laboratory\DATA\B18_EEG_data\EEGeyesopen.mat');
open = Open.eyesopen;
Closed = load('C:\Users\Alex\iCloudDrive\Documents\Ox Year 3\B18\B18-Wearables-Laboratory\DATA\B18_EEG_data\EEGeyesclosed.mat');
closed = Closed.eyesclosed;
%% Plot samples
fs = 256; %Sampling freq (Hz)
samples = 1:512;
time = samples./fs;

figure;
plot(time, closed(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title('Eyes Closed')

figure(2);
plot(time, open(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title('Eyes Open')

%% Pre-processing
%% Detrending and normalising
open = normalize(open-mean(open));
closed = normalize(closed - mean(closed));

%% Filtering
fc = 30; % cut−off frequency (Hz)
norder = 4; %filter order
%The cut-off frequency Wn must be 0.0<Wn<1.0;
Wn = fc/fs;
%Design the filter
[B,A] = butter(norder, Wn);
%Apply the LPF
open_f = filter(B,A,open);
closed_f = filter(B,A,closed);

%% Plot
figure(3)
plot(time, closed_f(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title(['Pre-processed Eyes Closed, fc=', num2str(fc), 'Hz'])

figure(4);
plot(time, open_f(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title(['Pre-processed Eyes Open, fc=', num2str(fc), 'Hz'])

%% Big plot
figure;

subplot(2,2,1);
plot(time, closed(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title('Eyes Closed')

subplot(2,2,2);
plot(time, open(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title('Eyes Open')

subplot(2,2,3);
plot(time, closed_f(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title(['Pre-processed Eyes Closed, fc=', num2str(fc), 'Hz'])

subplot(2,2,4);
plot(time, open_f(samples))
xlabel('Time (s)')
ylabel('Amplitude (\muV)')
title(['Pre-processed Eyes Open, fc=', num2str(fc), 'Hz'])

%% PSD
window = hamming(length(open_f));
[pxxO, fO] = periodogram(open_f, window, [], fs, 'psd');
[pxxOb, fOb] = periodogram(open, window, [], fs, 'psd');

window = hamming(length(closed_f));
[pxxC, fC] = periodogram(closed_f, window, [], fs, 'psd');
[pxxCb, fCb] = periodogram(closed, window, [], fs, 'psd');

figure
subplot(1,2,1)
plot(fCb, pxxCb);
xlim([0,60]);
title('Eyes Closed PSD pre processing')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

subplot(1,2,2)
plot(fOb, pxxOb);
xlim([0,60]);
title('Eyes Open PSD pre processing')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

figure
subplot(1,2,1)
plot(fC, pxxC);
xlim([0,60]);
title('Eyes Closed PSD post processing')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

subplot(1,2,2)
plot(fO, pxxO);
xlim([0,60]);
title('Eyes Open PSD post filtering')
xlabel('Frequency (Hz)')
ylabel('Power Spectral Density (mV^{2}Hz^{-1})')
axis square

