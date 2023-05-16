clc;
close all;
clear;
data1=load('preictal50.mat');
data=data1.preictal;

 
data2=data';
y=data2(1,:);

modes = meemd(y, 10, 10, 10);


% 1-D ensemble EMD
% written by Neil Po-Nan Li @ Inst. of Physics, Academia Sinica, Taiwan
% v1   2012/9/26
% v1.1 2014/3/17

function [modes] = meemd(y, goal, ens, nos)

stdy = std(y);
if stdy < 0.01
    stdy = 1;
end
y = y ./ stdy;

sz = length(y);
modes = zeros(goal+1, sz);

%%

parfor k = 1:ens
    disp(['Running ensemble #' num2str(k)]);
    wn = randn(1, sz) .* nos;
    y1 = y + wn;
    y2 = y - wn;
    modes = modes + emd(y1);
    if nos > 0 && ens > 1
        modes = modes + emd(y2);  
    end
end

%%

modes = modes .* stdy ./ (ens);
if nos > 0 && ens > 1
    modes = modes ./ 2;
end

end