
b18lab_pathname=pwd
data_pathname=[b18lab_pathname, filesep, 'DATA\B18_ECG_data']
file = 'PhysionetData.mat'
A = load([data_pathname, filesep, file])

b = A.RecordingInfo;
tabulate(b{:,2})