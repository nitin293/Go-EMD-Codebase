clc;
close all;
clear all;
data1=load('preictal50.mat');
data=data1.preictal;
data2=data';
a=data2;
plot(a);

c=sgolayfilt(a,3,127);

figure;
plot(c);

x1=a-c;
figure;
plot(x1);

a=x1;
% c=sgolayfilt(a,3,63);
figure;
plot(a);

x2=a-c;

figure;
plot(x2);


a=x2;
% c=sgolayfilt(a,3,31);
figure;
plot(a);

x3=a-c;

figure;
plot(x3);


a=x3;
% c=sgolayfilt(a,3,15);
figure;
plot(a);

x4=a-c;

figure;
plot(x4);


a=x4;
% c=sgolayfilt(a,3,7);
figure;
plot(a);

x5=a-c;

figure;
plot(x5);

figure
sg=(x1+x2+x3+x4+x5);
hold on; plot(data2,'-r');plot(sg,'-b');hold off;
legend('Original Signal', 'S-G Smoothed Signal')



