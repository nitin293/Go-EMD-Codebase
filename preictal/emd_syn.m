
fs=200;
Fs=200;

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
s=p;

tic

% p=plot(s(1:1024));
% title('EEG Signal')
count=0; 
itr=0;
% imf = emd(s);
% function imf = emd(s)

c = s(:)'; % copy of the input signal (as a row vector) original signal
% c=sgolayfilt(p,5,33);
% for input sine wave
% c=x;
N = length(c);


% loop to decompose the input signal into successive IMF

imf = []; % Matrix which will contain the successive IMF, and the residue

while (1) % the stop criterion is tested at the end of the loop
   
 
   % inner loop to find each imf
  
   h = c; % at the beginning of the sifting process, h is the signal
   SD = 1; % Standard deviation which will be used to stop the sifting process
   
   while SD > 0.3
      % while the standard deviation is higher than 0.3 (typical value)
      
      % find local max/min points
      d = diff(h); % approximate derivative
      maxmin = []; % to store the optima (min and max without distinction so far)
      for i=1:N-2
         if d(i)==0                        % we are on a zero
            maxmin = [maxmin, i];
         elseif sign(d(i))~=sign(d(i+1))   % we are straddling a zero so
            maxmin = [maxmin, i+1];        % define zero as at i+1 (not i)
         end
      end
      
      if size(maxmin,2) < 2 % then it is the residue
         break
      end
      
      % divide maxmin into maxes and mins
      if maxmin(1)>maxmin(2)              % first one is a max not a min
         maxes = maxmin(1:2:length(maxmin));
         mins  = maxmin(2:2:length(maxmin));
      else                                % is the other way around
         maxes = maxmin(2:2:length(maxmin));
         mins  = maxmin(1:2:length(maxmin));
      end
      
      % make endpoints both maxes and mins
      maxes = [1 maxes N];
      mins  = [1 mins  N];
      
      
      %-------------------------------------------------------------------------
      % spline interpolate to get max and min envelopes; form imf
      maxenv = spline(maxes,h(maxes),1:N);
      minenv = spline(mins, h(mins),1:N);
      
      m = (maxenv + minenv)/2; % mean of max and min enveloppes
      prevh = h; % copy of the previous value of h before modifying it

      h = h - m; % substract mean to h
       
      % calculate standard deviation
      eps = 0.0000001; % to avoid zero values
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
      itr=itr+1; 
   end
   
   imf = [imf; h]; % store the extracted IMF in the matrix imf
   % if size(maxmin,2)<2, then h is the residue
   count=count+1;
   % stop criterion of the algo.
    
   if size(maxmin,2) < 2
      break
   end

   c =c - h;
  
   % substract the extracted IMF from the signal
 

end

toc

finalitr=itr;
figure;
fig=figure;
for ii=1:count
    
  subplot(count,1,ii);
  plot(imf(ii,:));
  title(sprintf("IMF: %d",ii),'FontSize', 12);
 han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency');
xlabel(han,'Time');
title(han,'IMFs generated by EMD');    
end
hold off;


% return

% end
%code for PSD
Fs=200;
p=imf(:,1)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
 delta1 = bandpower(Pxx,F,[0 4],'psd');
 theta1=bandpower(Pxx,F,[4 8],'psd');
 alpha1 = bandpower(Pxx,F,[8 12],'psd');
 beta1=bandpower(Pxx,F,[12 35],'psd');
 gamma1=bandpower(Pxx,F,[35 70],'psd');
 p=imf(:,2)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
 delta2 = bandpower(Pxx,F,[0 4],'psd');
 theta2=bandpower(Pxx,F,[4 8],'psd');
 alpha2 = bandpower(Pxx,F,[8 12],'psd');
 beta2=bandpower(Pxx,F,[12 35],'psd');
 gamma2=bandpower(Pxx,F,[35 70],'psd');
 p=imf(:,3)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
 delta3 = bandpower(Pxx,F,[0 4],'psd');
 theta3=bandpower(Pxx,F,[4 8],'psd');
 alpha3 = bandpower(Pxx,F,[8 12],'psd');
 beta3=bandpower(Pxx,F,[12 35],'psd');
 gamma3=bandpower(Pxx,F,[35 70],'psd');
 p=imf(:,4)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
delta4 = bandpower(Pxx,F,[0 4],'psd');
 theta4=bandpower(Pxx,F,[4 8],'psd');
 alpha4 = bandpower(Pxx,F,[8 12],'psd');
 beta4=bandpower(Pxx,F,[12 35],'psd');
 gamma4=bandpower(Pxx,F,[35 70],'psd');
p=imf(:,5)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
delta5 = bandpower(Pxx,F,[0 4],'psd');
 theta5=bandpower(Pxx,F,[4 8],'psd');
 alpha5 = bandpower(Pxx,F,[8 12],'psd');
 beta5=bandpower(Pxx,F,[12 35],'psd');
 gamma5=bandpower(Pxx,F,[35 70],'psd');


rs = sum(imf); 

%code for reconstruction signal
 figure;
plot(t, x, 'b', 'LineWidth', 1.5); % Original signal in blue
hold on;
plot(t, rs, 'r', 'LineWidth', 1.5); % Signal with noise in red
legend('Original Signal', 'Reconstructed signal by EMD');
xlabel('Time');
ylabel('Amplitude');
title('Signal reconstruction');

hold off;

% RMSE and NMSE
% ---------------------

rmse_val = rmse(s', rs);
nmse_val = calNMSE(s', rs);

disp(strcat("RMSE EMD: ", num2str(rmse_val)));
disp(strcat("NMSE EMD: ", num2str(nmse_val)));

%%% code for SNR
 r = snr(s', rs);
 disp(strcat("SNR EMD: ", num2str(r)));
 
   % SSIM
ss = ssim(x, rs);
 % CC
cc = corrcoef(x, rs);
disp(strcat("CC GoEMD: ", num2str(cc)));
disp(strcat("SSIM GoEMD: ", num2str(ss)));