clc;
close all;
clear all;
data1=load('preictal50.mat');
data=data1.preictal;

 
 data2=data';
a=data2(1,:);
% plot(a);
% b=movmean(a,10);
c=sgolayfilt(a,3,25);

% figure;
% hold on;
% plot(a(1,1:100),'-b');
% plot(b(1,1:100),'-r');
% plot(c(1,1:100),'-k');
% hold off;

% emd(a,'Display',1);
[imf,res]= emd(a,'MaxNumIMF',5,'Display',1);
% [imf,res] = vmd(a,'NumIMFs',5);
% hht(imf);
% imf = emd(c, 5);
figure;
hold on;
% subplot(6,1,1);
% plot(a);

% ylabel('signal');
subplot(6,1,1);
plot(imf(:,1)');
title('EMD implementation of raw signal');
ylabel('IMF 1');
subplot(6,1,2);
plot(imf(:,2)');
ylabel('IMF 2');
subplot(6,1,3);
plot(imf(:,3)');
ylabel('IMF 3');
subplot(6,1,4);
plot(imf(:,4)');
ylabel('IMF 4');
subplot(6,1,5);
plot(imf(:,5)');
ylabel('IMF 5');
subplot(6,1,6);
plot(res');
 xlabel('time');
ylabel('RES');

hold off;
%PSD code
Fs=200;
p=imf(:,1)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
 delta1 = bandpower(Pxx,F,[1 4],'psd');
 theta1=bandpower(Pxx,F,[4 8],'psd');
 alpha1 = bandpower(Pxx,F,[8 13],'psd');
 beta1=bandpower(Pxx,F,[15 30],'psd');
 gamma1=bandpower(Pxx,F,[30 45],'psd');
 p=imf(:,2)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
 delta2 = bandpower(Pxx,F,[1 4],'psd');
 theta2=bandpower(Pxx,F,[4 8],'psd');
 alpha2 = bandpower(Pxx,F,[8 13],'psd');
 beta2=bandpower(Pxx,F,[15 30],'psd');
 gamma2=bandpower(Pxx,F,[30 45],'psd');
 p=imf(:,3)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
 delta3 = bandpower(Pxx,F,[1 4],'psd');
 theta3=bandpower(Pxx,F,[4 8],'psd');
 alpha3 = bandpower(Pxx,F,[8 13],'psd');
 beta3=bandpower(Pxx,F,[15 30],'psd');
 gamma3=bandpower(Pxx,F,[30 45],'psd');
 p=imf(:,4)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
delta4 = bandpower(Pxx,F,[1 4],'psd');
 theta4=bandpower(Pxx,F,[4 8],'psd');
 alpha4 = bandpower(Pxx,F,[8 13],'psd');
 beta4=bandpower(Pxx,F,[15 30],'psd');
 gamma4=bandpower(Pxx,F,[30 45],'psd');
p=imf(:,5)';
[Pxx,F] = periodogram(p,rectwin(length(p)),length(p),Fs);
delta5 = bandpower(Pxx,F,[1 4],'psd');
 theta5=bandpower(Pxx,F,[4 8],'psd');
 alpha5 = bandpower(Pxx,F,[8 13],'psd');
 beta5=bandpower(Pxx,F,[15 30],'psd');
 gamma5=bandpower(Pxx,F,[30 45],'psd');
 %code for variance of whole signal
wholevar = var(a)
wholemean  = mean(a);
%code for variance of imfs of signal after decomposition
s=imf(:,1)';
y1 = var(s)
meanyimf1  = mean(s);
s=imf(:,2)';
y2 = var(s)
meanyimf2  = mean(s);
s=imf(:,3)';
y3 = var(s)
meanyimf3  = mean(s);
s=imf(:,4)';
y4 = var(s)
meanyimf4  = mean(s);
s=imf(:,5)';
y5 = var(s)
meanyimf5  = mean(s);

ivar=y1+y2+y3+y4+y5;
imean=meanyimf1+meanyimf2+meanyimf3+meanyimf4+meanyimf5;
%code for standard deviation of whole signal
wholestd=std(a)
%code for standard deviation of imfs
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

istd=sv1+sv2+sv3+sv4+sv5;
%code for skewness of whole signal and resconstructed signal
wholesk = skewness(a)
tt=imf(:,1)+imf(:,2)+imf(:,3)+imf(:,4)+imf(:,5)+res
isk=skewness( tt )
%code for variance of whole signal and resconstructed signal
yvar = var(a)
tt=imf(:,1)+imf(:,2)+imf(:,3)+imf(:,4)+imf(:,5)+res
iyvar=var( tt )

% code for SSA
% N = length(a);
% t = (1:N)';
% newcolors = {'#F00','#F80','#FF0','#0B0','#00F','#50F','#A0F'};
% figure;
% colororder(newcolors)
% 
% set(gcf,'name','Original time series X and reconstruction RC')
% clf;
% plot(t,c,t,sum(imf(:,:),5));
% legend('Original','Complete reconstruction');

%code for sinewave figure 2
figure;
f=6; %frequency [Hz]
t=(0:1/(f*100):1);
a=1;    %amplitude [V]
phi=0;  %phase
y=a*sin(2*pi*f*t+phi);
subplot(2,1,1);
plot(y,'-k')
xlabel('time(s)')
ylabel('amplitude(V)')
title('Sine wave plot');
 z=sgolayfilt(y,3,25);
 subplot(2,1,2);
%  plot(y,'-k')
 hold on; plot(y,'-k','LineWidth',3);plot(z,'-oy');
 hold off;
 xlabel('time(s)')
ylabel('amplitude(V)')
legend('Original Signal', 'Golay fitting of sine wave')
title('Golay fitting of sine wave');