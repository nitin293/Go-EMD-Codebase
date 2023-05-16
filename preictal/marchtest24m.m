clc;
close all;
clear all;
% fs=500e3;
% f=1000;
% nCyl=5;
% tt=0:1/fs:nCyl*1/f;
% x=sin(2*pi*f*tt);
% figure;
% plot(tt,x)
% title('Continuous sinusoidal signal')
% xlabel('Time(s)');
% ylabel('Amplitude');

load preictal50.mat;
p=preictal;
y =p';
itr=0;
count=0; 
sift_i=0;
yy = p;
c=sgolayfilt(y,5,33);
% for input sine wave
% c=x;
N = length(c);


% loop to decompose the input signal into successive IMF

imf = []; % Matrix which will contain the successive IMF, and the residue

while (1) % the stop criterion is tested at the end of the loop
   
 
   % inner loop to find each imf
  
%    h = c; % at the beginning of the sifting process, h is the signal

   h=c;
  
   SD = 1; % Standard deviation which will be used to stop the sifting process
   
   while SD > 0.3
      % while the standard deviation is higher than 0.3 (typical value)
      
      % find local max/min points
      d = diff(h); % approximate derivative
      maxmin = []; % to store the optima (min and max without distinction so far)
      for i=1:N-2
         if d(i)==0                       % we are on a zero
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
      
%       b=sgolayfilt(maxenv,5,33);
%       c=sgolayfilt(maxenv,5,33);
%       m=(b+c)/2;

       m = (maxenv + minenv)/2; % mean of max and min enveloppes
      
        
      prevh = h; % copy of the previous value of h before modifying it

      
      h = h- m; % substract mean to h h = h+randn(size(m))- m; 
%       figure;
%     hold on
%     plot(c);
%     plot(maxenv,'-r');
%     plot(minenv,'-r');
%     plot(m,'-k');
%     hold off;
%     pause(5);
%     close all; 
      % calculate standard deviation
      eps = 0.0000001; % to avoid zero values
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
    itr=itr+1;  
   end
   sift_i=itr;
   imf = [imf; h]; % store the extracted IMF in the matrix imf
   % if size(maxmin,2)<2, then h is the residue
   count=count+1;
   
   % stop criterion of the algo.
    
   if size(maxmin,2) < 2
      break
   end
  
    %new code is here
   avgn=sum(imf(:)/1024);
   
   
   c =c- h-avgn*eps;
  
   % substract the extracted IMF from the signal

end
figure;
% for ii = [1 2 3 6 12]
 for ii=1:count
  subplot(count,1,ii);
  plot(imf(ii,:));
  xlabel('Time');
ylabel('Fq');
  title(sprintf("IMF: %d",ii));

end
finalitr=itr;
%Code for figure 6
figure;
  plot(imf(1,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 1');
    
figure;
  plot(imf(2,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 2');
figure;
  plot(imf(3,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 3');
    
figure;
  plot(imf(4,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 4');
  figure;
  plot(imf(5,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 5');
  figure;
  plot(imf(6,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 6');
  figure;
  plot(imf(7,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 7');
  figure;
  plot(imf(8,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 8');
  figure;
  plot(imf(9,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 9');
  figure;
  plot(imf(10,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 10');
  figure;
  plot(imf(11,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('IMF 11');
  figure;
  plot(imf(12,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('RES');
%code for variance of whole signal
wholevar = var(c)
%code for variance of imfs of signal after decomposition table IV
m=imf(:,1)';
y1 = var(m)
m=imf(:,2)';
y2 = var(m)
m=imf(:,3)';
y3 = var(m)
m=imf(:,4)';
y4 = var(m)
m=imf(:,5)';
y5 = var(m)
m=imf(:,6)';
y6 = var(m)
m=imf(:,7)';
y7 = var(m)
m=imf(:,8)';
y8 = var(m)
m=imf(:,9)';
y9 = var(m)
m=imf(:,10)';
y10 = var(m)
m=imf(:,11)';
y11 = var(m)
m=imf(:,12)';
y12 = var(m)
ivar=y1+y2+y3+y4+y5+y6+y7+y8+y9+y10+y11+y12;
%mean
wholemean = mean(c)
%code for mean of imfs of signal after decomposition for table IV
n=imf(:,1)';
my1 = mean(n)
n=imf(:,2)';
my2 = mean(n)
n=imf(:,3)';
my3 = mean(n)
n=imf(:,4)';
my4 = mean(n)
n=imf(:,5)';
my5 = mean(n)
n=imf(:,6)';
my6 = mean(n)
n=imf(:,7)';
my7 = mean(n)
n=imf(:,8)';
my8 = mean(n)
n=imf(:,9)';
my9 = mean(n)
n=imf(:,10)';
my10 = mean(n)
n=imf(:,11)';
my11 = mean(n)
n=imf(:,12)';
my12 = mean(n)
imean=my1+my2+my3+my4+my5+my6+my7+my8+my9+my10+my11+my12;
%code for standard deviation of whole signal
wholestd=std(c)
%code for standard deviation of imfs for tableIV
ss=imf(:,1)';
sv1=std(ss)

ss=imf(:,2)';
sv2=std(ss)
ss=imf(:,3)';
sv3=std(ss)
ss=imf(:,4)';
sv4=std(ss)
ss=imf(:,5)';
sv5=std(ss)
ss=imf(:,6)';
sv6=std(ss)
ss=imf(:,7)';
sv7=std(ss)
ss=imf(:,8)';
sv8=std(ss)
ss=imf(:,9)';
sv9=std(ss)
ss=imf(:,10)';
sv10=std(ss)
ss=imf(:,11)';
sv11=std(ss)
ss=imf(:,12)';
sv12=std(ss)
isd=sv1+sv2+sv3+sv4+sv5+sv6+sv7+sv8+sv9+sv10+sv11+sv12;
%code for skewness of whole signal and resconstructed signal for table IV
wholesk = skewness(c)
ss=imf(:,1)';
sk1=skewness(ss)

ss=imf(:,2)';
sk2=skewness(ss)
ss=imf(:,3)';
sk3=skewness(ss)
ss=imf(:,4)';
sk4=skewness(ss)
ss=imf(:,5)';
sk5=skewness(ss)
ss=imf(:,6)';
sk6=skewness(ss)
ss=imf(:,7)';
sk7=skewness(ss)
ss=imf(:,8)';
sk8=skewness(ss)
ss=imf(:,9)';
sk9=skewness(ss)
ss=imf(:,10)';
sk10=skewness(ss)
ss=imf(:,11)';
sk11=skewness(ss)
ss=imf(:,12)';
sk12=skewness(ss)

isk=sk1+sk2+sk3+sk4+sk5+sk6+sk7+sk8+sk9+sk10+sk11+sk12;
%code for PSD for table II
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
 
 %code for boxplot
%  figure;
%  boxplot(imf')
% xlabel('IMF')
% ylabel('Sifting Iterations')
% title('Box plot of GO-EMD')


%code for reconstruction signal fig 8(b)
% rs=imf(:,1)'+imf(:,2)'+imf(:,3)'+imf(:,4)'+imf(:,5)'+imf(:,6)'+imf(:,7)'+imf(:,8)'+imf(:,9)'+imf(:,10)'+imf(:,11)'+imf(:,12)'
rs=imf(1,:)+imf(2,:)+imf(3,:)+imf(4,:)+imf(5,:)+imf(6,:)+imf(7,:)+imf(8,:)+imf(9,:)+imf(10,:)+imf(11,:)+imf(12,:)
figure;
subplot(2,1,1);
plot(rs(1:999));
xlabel('time(s)')
title('Reconstructed signal from GO-EMD')
subplot(2,1,2);
plot(yy(1:999));
xlabel('time(s)')
ylabel('freq')
title('Original Signal')
% code for SSA for Fig 10
% t = (1:N)';
% newcolors = {'#F00','#F80','#FF0','#0B0','#00F','#50F','#A0F'};

% figure;
% colororder(newcolors)
% 
% set(gcf,'name','Singular Spectral analysis')
% clf;
% plot(t,c,t,sum(imf(:,:),12));
% ylabel('Power')
% xlabel('Frequency(Hz)')
% legend('Original','Complete reconstruction');
% title('SSA of IMFs produced using GO-EMD')
% figure;
%histogram plot
% histogram(imf);
% title('Histogram for IMFs generated by Go-EMD')
% xlabel('IMF(s)');
% ylabel('Iterations');

% figure;
%mesh plot
% mesh(imf);
% title('Mesh for IMFs generated by Go-EMD')
% xlabel('IMF(s)');
% ylabel('Occurence');

%code for SNR
 r = snr(yy, rs)

 %code for RMSE
 E = rmse(rs, yy)

 %nmse
 n = calNMSE(yy, rs);


 % SSIM
ss = ssim(yy', rs);


 % CC
cc = corrcoef(yy', rs);

for ii=1:11
%Code for figure 6
  figure;
  img = plot(imf(ii, 1:1000));
  xlabel('Time');
  ylabel('Freq');
  title(strcat('IMF ', int2str(ii)));
  outfile = strcat('Go_EMD_IMF_', int2str(ii), '.png')
  saveas(img, outfile);
end

  figure;
  fig = plot(imf(12,1:1000));
  xlabel('Time');
  ylabel('Freq');
  title('RES');
  saveas(fig, 'GoEMD_RES.png')

%code for reconstruction signal in one plot

yyy=yy';
figure;
plot(rs(1:999),'-b'); hold on;
plot(yyy(1:999),'-r');
ylabel('freq')
xlabel('time(s)')
title('Reconstructed signal from GO-EMD') ;
legend('Reconstructed Signal by Go-EMD','Original EEG signal')
hold off;