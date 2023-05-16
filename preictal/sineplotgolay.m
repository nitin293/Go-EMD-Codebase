clear;
clc;
close;
f=3; %frequency [Hz]
t=(0:1/(f*100):1);
a=1;    %amplitude [V]
phi=0;  %phase
y=a*sin(2*pi*f*t+phi);
% plot(t,y)
% xlabel('time(s)')
% ylabel('amplitude(V)')
c=sgolayfilt(y,5,99);

figure;
hold on;
plot(y(1,1:300),'-b','LineWidth',3);
plot(c(1,1:300),'-or');
title('Savitzky-Golay fitting of sine wave')
xlabel('time(s)')
ylabel('amplitude(V)')
legend('sin wave','filtered sine wave')
hold off;