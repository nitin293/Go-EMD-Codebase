clc;
close all;
clear;

%loading ECG signal
fs=1000;
x=load('ecg1.mat');
g=x.val/2000;
g=g';
g=g(1:10*fs,1);
plot(g);

N = length(g);
p=g';

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
%  figure;
% plot(t, x, 'b', 'LineWidth', 1.5); % Original signal in blue
% hold on;
% plot(t, rs, 'r', 'LineWidth', 1.5); % Signal with noise in red
% legend('Original Signal', 'Reconstructed signal by EEMD');
% xlabel('Time');
% ylabel('Amplitude');
% title('Signal reconstruction');
% 
% hold off;

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
t = (1:N)';
%code for reconstruction signal
 figure;
plot(t, g, 'b', 'LineWidth', 1.5); % Original signal in blue
hold on;
plot(t, rs, 'r', 'LineWidth', 1.5); % Signal with noise in red
legend('Original Signal', 'Reconstructed signal by EEMD');
xlabel('Time');
ylabel('Amplitude');
title('Signal reconstruction');

hold off;

% RMSE and NMSE
% ---------------------

rmse_val = rmse(p', rs);
nmse_val = calNMSE(p', rs);

disp(strcat("RMSE EEMD: ", num2str(rmse_val)));
disp(strcat("NMSE EEMD: ", num2str(nmse_val)));

  % SSIM
ss = ssim(p', rs);
 % CC
cc = corrcoef(p', rs);
disp(strcat("CC GoEMD: ", num2str(cc)));
disp(strcat("SSIM GoEMD: ", num2str(ss)));
