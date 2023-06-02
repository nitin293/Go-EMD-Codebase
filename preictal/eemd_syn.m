clc;
close all;
clear;

% synthetic signal

% Define your signal 'x'
t = 0:0.01:1; % Define the time axis
x = sin(2*pi*5*t); % Example signal: sine wave

% Add random noise
noise_amplitude = 0.2; % Adjust the amplitude of the noise as desired
noise = noise_amplitude * randn(size(x)); % Generate random noise
x_with_noise = x + noise; % Add noise to the signal

% Plot the original signal and the signal with noise
figure;
plot(t, x, 'b', 'LineWidth', 1.5); % Original signal in blue
hold on;
plot(t, x_with_noise, 'r', 'LineWidth', 1.5); % Signal with noise in red
legend('Original Signal', 'Signal with Noise');
xlabel('Time');
ylabel('Amplitude');
title('Signal with Random Noise');
p=x;
% dd = data;
data=p';
dd=data;
tic

data = sgolayfilt(data', 5, 33);
zz = data;
imf = eemd(data, 12, 1, 1.2);

toc

[nrow, ncol] = size(imf);

featurematrix = [];

%code for PSD for table II
Fs=200;
for ii=1:nrow
    
    p=imf(ii, :)';
    [Pxx, F] = periodogram(p, rectwin(length(p)), length(p), Fs);
%     delta = bandpower(Pxx,F,[0 4],'psd');
%     theta = bandpower(Pxx,F,[4 8],'psd');
    alpha = bandpower(Pxx,F,[8 12],'psd');
    beta = bandpower(Pxx,F,[12 35],'psd');
    gamma = bandpower(Pxx,F,[35 70],'psd'); 

%     featurematrix(ii, 1) = delta;
%     featurematrix(ii, 2) = theta;
    featurematrix(ii, 1) = alpha;
    featurematrix(ii, 2) = beta;
    featurematrix(ii, 3) = gamma;


end


%% No. of iteration = goal * ens * itr [from emd.m]
%% 

rs = [];
for ii=1:ncol
    rs(1, ii) = sum(imf(:, ii));
end
c=data;

%CODE for IMF plot Figure 10
 for ii=1:12
  subplot(12,1,ii);
  plot(imf(ii,:));
  xlabel('Time');
ylabel('Fq');
  title(sprintf("IMF: %d",ii));
if ii==12
   subplot(12,1,ii);
  plot(imf(ii,:));
  xlabel('Time');
ylabel('Fq');
  title(sprintf("RES")); end
 end
%code for reconstruction figure 8

% rs=imf(1,:)+imf(2,:)+imf(3,:)+imf(4,:)+imf(5,:)+imf(6,:)+imf(7,:)+imf(8,:)+imf(9,:)+imf(10,:)+imf(11,:)+imf(12,:);
% yy=data;

rs = sum(imf); 

%code for reconstruction signal
 figure;
plot(t, x, 'b', 'LineWidth', 1.5); % Original signal in blue
hold on;
plot(t, rs, 'r', 'LineWidth', 1.5); % Signal with noise in red
legend('Original Signal', 'Reconstructed signal by EEMD');
xlabel('Time');
ylabel('Amplitude');
title('Signal reconstruction');

hold off;

%code for SNR
%%% code for SNR
 r = snr(zz, rs);
 disp(strcat("SNR EEMD: ", num2str(r)));

 %code for RMSE
 E = rmse(zz, rs);


 %nmse
 n = calNMSE(zz, rs);


 % SSIM
ss = ssim(zz, rs);
 % CC
cc = corrcoef(zz, rs);

% for ii=1:12
% %Code for figure 6
%   figure;
%   img = plot(imf(ii, 1:1000));
%   xlabel('Time');
%   ylabel('Freq');
%   title(strcat('IMF ', int2str(ii)));
%   outfile = strcat('EEMD_IMF_', int2str(ii), '.png')
%   saveas(img, outfile);
% end


%   figure;
%   fig = plot(imf(13,1:1000));
%   xlabel('Time');
%   ylabel('Freq');
%   title('RES');
%   saveas(fig, 'EEMD_RES.png')
%   %code for reconstruction signal in one plot
% 
% yyy=zz';
% figure;
% plot(rs(1:999),'-b'); hold on;
% plot(yyy(1:999),'-r');
% ylabel('freq')
% xlabel('time(s)')
% title('Reconstructed signal from EEMD') ;
% legend('Reconstructed Signal by EEMD','Original EEG signal')
% hold off;


% RMSE and NMSE
% ---------------------

rmse_val = rmse(dd', rs);
nmse_val = calNMSE(dd', rs);

disp(strcat("RMSE EEMD: ", num2str(rmse_val)));
disp(strcat("NMSE EEMD: ", num2str(nmse_val)));

  % SSIM
ss = ssim(x, rs);
 % CC
cc = corrcoef(x, rs);
disp(strcat("CC GoEMD: ", num2str(cc)));
disp(strcat("SSIM GoEMD: ", num2str(ss)));
