% clear;
close all;
clc;

[n, values] = size(goemd_imf);

emd_imf_ffts = [];
eemd_imf_ffts = [];
goemd_imf_ffts = [];

for ii=1:12
    emd_fft_val = abs(fft(emd_imf(ii, :)));
    eemd_fft_val = abs(fft(eemd_imf(ii, :)));
    goemd_fft_val = abs(fft(goemd_imf(ii, :))); 
    
    fig = figure;
    title(strcat("IMF: ", int2str(ii)));
    
    subplot(1, 3, 1);
    spectrogram(emd_fft_val);

    subplot(1, 3, 2);
    spectrogram(eemd_fft_val);

    subplot(1, 3, 3);
    spectrogram(goemd_fft_val);
end


