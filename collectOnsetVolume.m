function onsetList = collectOnsetVolume(resp, baseName)

% Unit : scan
nTrInBlockROI = 14;
nTrInBlockReg = 14;
nTrInBlockMotorROI = nTrInBlockROI - 4; % Motor block started at 11th block; 4 tr
nTrInBlockMotorReg = nTrInBlockReg - 4; % Motor block started at 11th block; 4 tr
nTrInBlockFixation = 10; % Fixation block: 10 tr

nConInFunction = 2;
nConInRegular = 4;
tr = 2;

% For functional ROI
vLength = length(resp.functional);
nFunctionalROI = vLength;
nFixationBlock = nFunctionalROI/2;
fixationAS = nTrInBlockFixation*[0:nFixationBlock-1];
% Adding numbers after regular session
for j = 1:vLength,
	blockSeq(j) = resp.functional{1,j}.blockSeq(1);

	% Calculating motor onset
	rtMri(1, j) = resp.functional{1,j}.idiom.respTimeMri(1);
	rtMri(2, j) = fix((rtMri(1,j)-0.01)/tr);
end

%nRegularSession = 0;
% For regular session
vLength = length(resp.main);
nRegularSession = vLength;
for j = 1:vLength,
	blockSeq(nFunctionalROI + j) = resp.main{1,j}.blockSeq(1);

	% Calculating motor onset
	rtMri(1, nFunctionalROI + j) = resp.main{1,j}.character.respTimeMri(1);
	rtMri(2, nFunctionalROI + j) = fix((rtMri(1,nFunctionalROI + j)-0.01)/tr); % 0.01, corrected for rt=2 will counted in next scan
	rtMri(3, nFunctionalROI + j) = resp.main{1,j}.idiom.respTimeMri(1);
	rtMri(4, nFunctionalROI + j) = fix((rtMri(3,nFunctionalROI + j)-0.01)/tr);


	%if resp.main{1,j}.character.keyCodeMri == 52, % Not aware any characters
	%	visibilityIx(1, j) = 1;
	%else,
	%	visibilityIx(1, j) = 0;
	%end

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


% onsetList Row: 1 for block; 2 for motor; 3 for Raw index for rtMri index
% 4 for motor corrected; 5 for fixation period, aka, baseline.
% i:1 for Idiom; 2 for Random;
for i = 1:nConInFunction,
	onsetList{1, i} = ([find((blockSeq(1:nFunctionalROI)==i) | (blockSeq(1:nFunctionalROI)==i + 2))] - 1)*nTrInBlockROI + 1 + fixationAS;
	onsetList{2, i} = onsetList{1, i} + nTrInBlockMotorROI;
	%onsetList{3, i} = onsetList{1, nConInRegular + i} + nTrInBlockFixation;
	onsetList{3, i} = [find((blockSeq(1:nFunctionalROI)==i) | (blockSeq(1:nFunctionalROI)==i + 2))]; % Raw index for rtMri index
	onsetList{4, i} = onsetList{2, i} + rtMri(2, onsetList{3, i}); % Idiom; Response period plus offset scan due to reaction time
end
onsetList{5, 1} = nTrInBlockROI*nConInFunction*[1:nFixationBlock] + fixationAS + 1; % Fixation onset list

%224*4+304=1200 % Total EPI scan

%nConInRegular = 0;
% i = blockSeq: 1 for CFS Idiom; 2 for CFS Random; 3 for superimpose idiom; 4 for superimpose Random
% onsetList Row: 1 for block; 2 for motor; 3 for Raw index for rtMri index
% 4 for motor_idiom corrected; 6 for motor_Character corrected;
trimIx = 6; % trimIx + 1 for excluding visible block; trimIx + 2 ..
onsetList{5, 2} = 'trimIx';  onsetList{5, 3} = trimIx; % For recording
for i = 1:nConInRegular,
	% Multiply with number of volumes in each block
	onsetList{1, nConInFunction + i} = ([find(blockSeq(nFunctionalROI + 1 : nFunctionalROI + nRegularSession)==i)] - 1)*nTrInBlockReg + 1 + nFixationBlock*(nTrInBlockFixation + nTrInBlockROI*nConInFunction);
	onsetList{2 ,nConInFunction + i} = onsetList{1, nConInFunction + i} + nTrInBlockMotorReg;
	%onsetList{3, nConInFunction + i} = onsetList{1, nConInFunction + i} + nTrInBlockFixation;
	onsetList{3, nConInFunction + i} = [find(blockSeq(nFunctionalROI + 1 : nFunctionalROI + nRegularSession)==i)]; % Raw index for rtMri index
	onsetList{4, nConInFunction + i} = onsetList{2, nConInFunction + i} + rtMri(4, onsetList{3, nConInFunction + i}) + 2; % Idiom; Response period plus offset scan due to reaction time
	onsetList{6, nConInFunction + i} = onsetList{2, nConInFunction + i} + rtMri(2, onsetList{3, nConInFunction + i}); % Character; Response period plus offset scan due to reaction time


	% Row below is data after delete visible block
	% Input: trimIx + [1 4]; 4 is the sort mix of idiom and character motor
	onsetList{trimIx + 1, nConInFunction + i} = onsetList{1, nConInFunction + i}(find(visibilityIx(find(blockSeq(nFunctionalROI + 1 : nFunctionalROI + nRegularSession) == i)) == 1)); % Excluding visible block
	onsetList{trimIx + 2 ,nConInFunction + i} = onsetList{trimIx + 1, nConInFunction + i} + nTrInBlockMotorReg;
	%onsetList{3, nConInFunction + i} = onsetList{1, nConInFunction + i} + nTrInBlockFixation;
	onsetList{trimIx + 3, nConInFunction + i} = [find(visibilityIx(find(blockSeq(nFunctionalROI + 1 : nFunctionalROI + nRegularSession)==i)) == 1)]; % Raw index for rtMri index
	%onsetList{trimIx + 4, nConInFunction + i} = onsetList{trimIx + 2, nConInFunction + i} + rtMri(4, onsetList{trimIx + 3, nConInFunction + i}) + 2; % Idiom; Response period plus offset scan due to reaction time
	%onsetList{trimIx + 5, nConInFunction + i} = onsetList{trimIx + 2, nConInFunction + i} + rtMri(2, onsetList{trimIx + 3, nConInFunction + i}); % Character; Response period plus offset scan due to reaction time
	%onsetList{trimIx + 6, nConInFunction + i} = sort([onsetList{trimIx + 4, nConInFunction + i} onsetList{trimIx + 5, nConInFunction + i}], 2);
	
	% Change the row sequence
	onsetList{trimIx + 5, nConInFunction + i} = onsetList{trimIx + 2, nConInFunction + i} + rtMri(4, onsetList{trimIx + 3, nConInFunction + i}) + 2; % Idiom; Response period plus offset scan due to reaction time
	onsetList{trimIx + 6, nConInFunction + i} = onsetList{trimIx + 2, nConInFunction + i} + rtMri(2, onsetList{trimIx + 3, nConInFunction + i}); % Character; Response period plus offset scan due to reaction time
	onsetList{trimIx + 4, nConInFunction + i} = sort([onsetList{trimIx + 5, nConInFunction + i} onsetList{trimIx + 6, nConInFunction + i}], 2);
end
% Put ROI onset in
for i = 1:nConInFunction,
	onsetList{trimIx + 1, i} = onsetList{1, i};
	onsetList{trimIx + 4, i} = onsetList{4, i};
end;


%%[pathstr, filename, ext] = fileparts(fileName);
tmp = ['onsetList_' baseName '.mat'];
%%saveFileName = fullfile('', [tmp ext]);
save(tmp, 'onsetList')
