function interData = statIntermediate(resp)

[functionalIdiomAC regularIdiomAC] = extractIdiomAccurateRate(resp);

%nRegularSession = 0; % Only if just have functionalROI
%nConInRegular = 0; % Only if just have functionalROI

% For functional ROI
vLength = length(resp.functional);
nFunctionalROI = vLength;
for j = 1:vLength,
	% Adding numbers after regular session
	blockSeq(j) = resp.functional{1,j}.blockSeq(1);
end

% For regular session
vLength = length(resp.main);
nRegularSession = vLength;
for j = 1:vLength,
	blockSeq(nFunctionalROI + j) = resp.main{1,j}.blockSeq(1);
end


% Collect the block index of each condition
nConInFunction = 2;
for i = 1:nConInFunction,
	blockIndex{i}=[find((blockSeq(1:nFunctionalROI)==i) | (blockSeq(1:nFunctionalROI)==i + 2))];
end

% 1 for CFS idiom; 2 for CFS random; 3 for superimpose idiom; 4 for superimpose random
nConInRegular = 4;
for i = 1:nConInRegular,
	blockIndex{nConInFunction + i}=[find(blockSeq(nFunctionalROI + 1 : nFunctionalROI + nRegularSession)==i)] + nFunctionalROI;
end


% Extract keycode
% For functional ROI
for j = 1:nFunctionalROI,
	idiomResp(j) = resp.functional{1,j}.idiom.keyCodeMri(1);

	% For keyboard input; testing purpose; only in testing functionROI
	%idiomResp(nRegularSession + j) = resp.functional{1,j}.idiom.keyCode(1);
end

% For regular session
for j = 1:nRegularSession,
	idiomResp(nFunctionalROI + j) = resp.main{1,j}.idiom.keyCodeMri(1);
	charResp(nFunctionalROI + j) = resp.main{1,j}.character.keyCodeMri(1);
	textContrastState(j) = resp.main{1,j}.textContrastState(1);

	switch fix((resp.main{1,j}.blockSeq(1)-1)/2),
		case 0,
			% Unvisible block == 1; only included unvisible block
			if resp.main{1,j}.character.keyCodeMri == 52, % Not aware any characters
				visibilityIx(1, j) = 1;
			else,
				visibilityIx(1, j) = 0;
			end

		case 1,
			% All block will be included
			if resp.main{1,j}.character.keyCodeMri == 52, % Not aware any characters
				visibilityIx(1, j) = 1;
			else,
				visibilityIx(1, j) = 1;
			end

		%otherwise,
		%	visibilityIx(1, j) = 1;
	end
end


summaryKeyFun = [blockSeq(1:nFunctionalROI); idiomResp(1:nFunctionalROI); functionalIdiomAC; charResp(1:nFunctionalROI)];

summaryKeyRegRaw = [blockSeq(nFunctionalROI + 1 : nFunctionalROI + nRegularSession); idiomResp(nFunctionalROI + 1 : nFunctionalROI + nRegularSession); regularIdiomAC; charResp(nFunctionalROI + 1 : nFunctionalROI + nRegularSession); textContrastState];

% After delete data
summaryKeyReg = [blockSeq(nFunctionalROI + find(visibilityIx == 1)); idiomResp(nFunctionalROI + find(visibilityIx == 1)); regularIdiomAC(find(visibilityIx == 1)); charResp(nFunctionalROI + find(visibilityIx == 1)); textContrastState(find(visibilityIx == 1))];

% Summary of all accuracy rate
% Row 1= blockIndex; 2= idiom response; 3= idiom expected answer
ROI_idiom = ...
(sum(summaryKeyFun(2,:) == 51 & (summaryKeyFun(1,:) == 1 | summaryKeyFun(1,:) == 3)...
& summaryKeyFun(3,:) == 1) + ...
sum(summaryKeyFun(2,:) == 52 & (summaryKeyFun(1,:) == 1 | summaryKeyFun(1,:) == 3)...
& summaryKeyFun(3,:) == 0))*2/nFunctionalROI

ROI_random = ...
(sum(summaryKeyFun(2,:) == 51 & (summaryKeyFun(1,:) == 2 | summaryKeyFun(1,:) == 4)...
& summaryKeyFun(3,:) == 1) + ...
sum(summaryKeyFun(2,:) == 52 & (summaryKeyFun(1,:) == 2 | summaryKeyFun(1,:) == 4)...
& summaryKeyFun(3,:) == 0))*2/nFunctionalROI

% yes: 51; Row 1= blockIndex; 2= idiom response from participants; 3 idiom answer; 4 char response

%CFS_idiom = ...
%(sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 1 & summaryKeyReg(3,:) == 1) + ...
%sum(summaryKeyReg(2,:) == 52 & summaryKeyReg(1,:) == 1 & summaryKeyReg(3,:) == 0))*4/nRegularSession
%CFS_random = ...
%(sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 2 & summaryKeyReg(3,:) == 1) + ...
%sum(summaryKeyReg(2,:) == 52 & summaryKeyReg(1,:) == 2 & summaryKeyReg(3,:) == 0))*4/nRegularSession

CFS_idiom = ...
(sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 1 & summaryKeyReg(3,:) == 1) + ...
sum(summaryKeyReg(2,:) == 52 & summaryKeyReg(1,:) == 1 & summaryKeyReg(3,:) == 0))/sum(summaryKeyReg(1,:) == 1)

CFS_random = ...
(sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 2 & summaryKeyReg(3,:) == 1) + ...
sum(summaryKeyReg(2,:) == 52 & summaryKeyReg(1,:) == 2 & summaryKeyReg(3,:) == 0))/sum(summaryKeyReg(1,:) == 2)

Superimpose_idiom = ...
(sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 3 & summaryKeyReg(3,:) == 1) + ...
sum(summaryKeyReg(2,:) == 52 & summaryKeyReg(1,:) == 3 & summaryKeyReg(3,:) == 0))*4/nRegularSession

Superimpose_random = ...
(sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 4 & summaryKeyReg(3,:) == 1) + ...
sum(summaryKeyReg(2,:) == 52 & summaryKeyReg(1,:) == 4 & summaryKeyReg(3,:) == 0))*4/nRegularSession


CFS_idiomChar = sum(summaryKeyRegRaw(4,:) == 51 & summaryKeyRegRaw(1,:) == 1)*4/nRegularSession
CFS_randomChar = sum(summaryKeyRegRaw(4,:) == 51 & summaryKeyRegRaw(1,:) == 2)*4/nRegularSession
Superimpose_idiomChar = sum(summaryKeyRegRaw(4,:) == 51 & summaryKeyRegRaw(1,:) == 3)*4/nRegularSession
Superimpose_randomChar = sum(summaryKeyRegRaw(4,:) == 51 & summaryKeyRegRaw(1,:) == 4)*4/nRegularSession


CFS_stimuli_contrast = ...
	mean(summaryKeyReg(5, find((summaryKeyReg(1,:) == 1 | (summaryKeyReg(1,:) == 2)))))


%% For Keyboard usage in mac mini
%% Row 1= blockIndex; 2= idiom response; 3= idiom answer ; 80=51; 79=52;


interData = [ROI_idiom ROI_random CFS_idiom CFS_random Superimpose_idiom Superimpose_random CFS_idiomChar CFS_randomChar Superimpose_idiomChar Superimpose_randomChar CFS_stimuli_contrast]


% Only for test functionalROI
%interData = [idiomRateFun idiomRateFun_random]

%% Incrementally save data to intermediate file
%saveFileName = 'intermediate';
%if exist([saveFileName '.mat'], 'file')
%	%save([saveFileName '.mat'], 'interDate', '-append')
%	interDataTmp = interData;
%	load([saveFileName '.mat'])
%	l = size(interData);
%	interData(l(1)+1, :) = interDataTmp;
%	save([saveFileName '.mat'], 'interData')
%else
%	save([saveFileName '.mat'], 'interData')
%end

% Obsolete; This part only calculate the cumulative frequency of output
%idiomRateReg = sum(summaryKeyReg(2,:) == 51 & summaryKeyReg(1,:) == 2)*2/nRegularSession
%charRate = sum(charResp == 51)/vLength
%idiomRate = sum(idiomResp == 51)/vLength
