%resp.main{1,1}.trialSot(1,10) - resp.main{1,2}.tbStamp

%% test each trial time lag
%% Result: all time slot are below 2 seconds
%for j = 1:64,
%	for i = 0:8,
%		a = resp.main{1,j}.trialSot(1,10 - i) - resp.main{1,j}.trialSot(1,9 - i)
%		if a >= 2,
%			sprintf('indexTrial : %d, %d', j, i)
%		end
%	end
%end


%% Testing the interval between blocks
%for j = 1:63,
%	%a = resp.main{1,j + 1}.tStamp - resp.main{1,j}.tStamp
%	a = resp.main{1,j + 1}.bStamp - resp.main{1,j}.bStamp
%	if a >= 29,
%		sprintf('indexBlock : %d', j)
%	end
%end


%% Show which key pressed
%for j = 1:64,
%	a = resp.main{1,j}.idiom.keyCodeMri;
%	if a >= 2,
%		%sprintf('index : %d', j)
%	end
%end


% This part is for testing localizer run in developing
%for j = 1:15,
for j = 1:7,
	%for i = 0:8,
	   %a = resp.functional{1,j}.trialSot(1,10 - i) - resp.functional{1,j}.trialSot(1,9 - i)
	   a = resp.functional{1,j}.trialSot(1,2) - resp.functional{1,j}.trialSot(1,1)
	   %if a >= 2,
	   %	sprintf('indexTrial : %d, %d', j, i)
	   %end
	%end
end


for j = 2:2:8,
	b = resp.functional{1,j}.bStampFix - resp.functional{1,j+1}.bStamp
	%b = resp.functional{1,j}.bStamp - resp.functional{1,j}.bStampFix
	%b = resp.functional{1,j}.tbStamp - resp.functional{1,j}.tbStampFix
	%b = resp.functional{1,j + 1}.tbStampFix - resp.functional{1,j}.tbStampFix
	%b = resp.functional{1,j + 1}.tStamp - resp.functional{1,j}.tStamp
	%b = resp.functional{1,j + 1}.bStamp - resp.functional{1,j}.bStamp
	%if a >= 29,
	%	sprintf('indexBlock : %d', j)
	%end
end

%% For extract response
%for j = 1:16,
%	a = resp.functional{1,j}.idiom.respTimeMri
%end

