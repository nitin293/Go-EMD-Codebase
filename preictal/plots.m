    %% EEMD: {

%%	'Dataset': 'preictal50.mat',
% 	'Parameters': {
% 		y: data', 
% 		goal: 5, 
% 		ens: 1, 
% 		nos: 10,
% 	}
% 
% }
% 
% 
% ----------------
% CODE
% ----------------

% load('preictal50.mat');


data = preictal';

ed = eemd(data', 5, 1, 10);
[row col] = size(ed);

figure;
for ii=1:row
	subplot(row, 1, ii);
	plot(ed(ii, :));
	hold on;
end

hold off;