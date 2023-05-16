% S --> ORIGINAL SIGNAL
% RS --> RECONSTRUCTED SIGNAL

s = p;

alpha = bandpass(s, [8 13], 200);
beta = bandpass(s, [13 30], 200);
gamma = bandpass(s, [30 50], 200);

alpha_rs = bandpass(rs, [8 13], 200);
beta_rs = bandpass(rs, [13 30], 200);
gamma_rs = bandpass(rs, [30 50], 200);

figure
title('ORIGINAL')
subplot(3, 1, 1)
plot(alpha);
subplot(3, 1, 2)
plot(beta);
subplot(3, 1, 3)
plot(gamma);

figure
title('RECONSTRUCTED')
subplot(3, 1, 1)
plot(alpha_rs);
subplot(3, 1, 2)
plot(beta_rs);
subplot(3, 1, 3)
plot(gamma_rs);

