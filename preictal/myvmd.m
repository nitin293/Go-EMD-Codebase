fs = 1e3;
t = 0:1/fs:1-1/fs;

x = 6*t.^2 + cos(4*pi*t+10*pi*t.^2) + ...
    [cos(60*pi*(t(t<=0.5))) cos(100*pi*(t(t>0.5)-10*pi))];

tiledlayout('flow')
nexttile
plot(t,[zeros(1,length(t)/2) cos(100*pi*(t(length(t)/2+1:end))-10*pi)])
xlabel('Time (s)')
ylabel('Cosine')

nexttile
plot(t,[cos(60*pi*(t(1:length(t)/2))) zeros(1,length(t)/2)])
xlabel('Time (s)')
ylabel('Cosine')

nexttile
plot(t,cos(4*pi*t+10*pi*t.^2))
xlabel('Time (s)')
ylabel('Chirp')


nexttile
plot(t,6*t.^2)
xlabel('Time (s)')
ylabel('Quadratic trend')

nexttile(5,[1 2])
plot(t,x)
xlabel('Time (s)')
ylabel('Signal')
[imf,res] = vmd(x,'NumIMFs',4);

tiledlayout('flow')

for i = 1:4
    nexttile
    plot(t,imf(:,i))
    txt = ['IMF',num2str(i)];
    ylabel(txt)
    xlabel('Time (s)')
    grid on
end
sig = sum(imf,2) + res;

nexttile(5,[1 2])
plot(t,sig,'LineWidth',1.5)

hold on

plot(t,x,':','LineWidth',2)
xlabel('Time (s)')
ylabel('Signal')
hold off
legend('Reconstructed signal','Original signal', ...
       'Location','northwest')