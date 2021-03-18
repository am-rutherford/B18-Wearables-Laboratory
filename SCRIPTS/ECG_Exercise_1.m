%% Load Data
b18lab_pathname=pwd;
data_pathname=[b18lab_pathname, filesep, 'DATA', filesep, 'B18_ECG_data'];
file = 'PhysionetData.mat';
A = load([data_pathname, filesep, file]);

%% 1. run tabulate analysis
b = A.RecordingInfo;
tabulate(b{:,2})

%% 2. plot ECG data
fs = 300;  % sampling frequency
signal = A.Signals{3};  % get 'A00808' which is N
samples = 1:length(signal);
time = samples./fs;
range = [find(time==15.47):find(time==18.40)];

figure;
plot(time(range), signal(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Normal Rhythm; Recording: A00808')
text(15.66,40,'P')
text(16.1,-45,'Q')
text(16.15,480,'R')
text(16.23,-110,'S')
text(16.46,155,'T')

%% 3. Visualising all classes
sigN = A.Signals{16};
sigO = A.Signals{1};
sigA = A.Signals{4};
sigT = A.Signals{2};
range = [find(time==15.47):find(time==20.00)];

% plots
figure;
subplot(2,2,1);
plot(time(range), sigN(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Normal Rhythm; Recording: A04984')

subplot(2,2,2);
plot(time(range), sigO(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Other Rhythm; Recording: A04982')

subplot(2,2,3);
plot(time(range), sigA(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('AFib Rhythm; Recording: A03605')

subplot(2,2,4);
plot(time(range), sigT(range))
xlabel('Time (s)')
ylabel('Amplitude (mV)')
title('Noisy Recording; Recording: A05233')





