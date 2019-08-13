function regularIdiomAC = extractAccurateRatePretest(resp, experimentPars)
% This is for extract information for calculating accurate rate of idiom recognition in Funcitonal ROI
%clear all
%load(dataSet)

%regularIdiomAC = 0; % For functionalROI test

% Inherit from Regular session
nRunRegular = 1;
%nRunRegular = experimentPars.runsPretest;
nBlockRepe = 4;
%nBlockRepe = experimentPars.nBolckRepetitionInRun;
nBlockCondition = 4;
%nBlockCondition = experimentPars.nCondition;
nBlockRegular = nRunRegular*nBlockRepe*nBlockCondition;
%nBlockRegular = 8;
vLength = length(resp.main);
nBlockRegular = vLength;


for i = 1:nBlockRegular,
	blockSeqIndexRegular(i) = resp.main{1, i}.blockSeq;
end

j = 1; %resp.iBlockRepe
k = 1;
for i = 1:length(blockSeqIndexRegular)
	% Wrong version
	%regularIdiomAC(i) = g.testIdiomCondition{k}{blockSeqIndexRegular(i)}(mod(j, 2) + 1);

	% Correct version
	%regularIdiomAC(i) = g.testIdiomCondition{k}{blockSeqIndexRegular(i)}(mod(j, 4) + 1);

	% g.testIdiomCondition can be changed to resp.testIdiomCondition
	regularIdiomAC(i) = resp.testIdiomCondition{k}{blockSeqIndexRegular(i)}(mod(j-1, 4) + 1);
	if mod(i, 4) == 0,
		j = j + 1;
	end
	if mod(i, 16) == 0,
		k = k + 1;
	end
end


%% functionalROI
%nRunFuncitonal = 1;
%nBlockRepe = 4;
%nBlockFunctional = 16;
%
%% For reconstructing from blockSeq
%for i = 1:nBlockFunctional,
%blockSeqIndexFunction(i) = resp.functional{1, i}.blockSeq;
%end
%
%j = 1; %resp.iBlockRepe
%for i = 1:length(blockSeqIndexFunction)
%	%functionalIdiomAC(i) = g.functionIdiomCondition{1}{blockSeqIndexFunction(i)}(j);
%
%	% g.functionIdiomCondition can be changed to resp.functionIdiomCondition
%	functionalIdiomAC(i) = resp.functionIdiomCondition{1}{blockSeqIndexFunction(i)}(j);
%	if mod(i, 4) == 0,
%		j = j + 1;
%	end
%end

% functionalROI idiom AC
% Forward re-construction
%l = 1;
%for i = 1:nRunFuncitonal,
%	for j = 1:nBlockRepe,
%		for k = 1:4,
%			functionalIdiomAC_2(l) = g.functionIdiomCondition{i}{resp.blockSeq{i}(j, k)}(j);
%			l = l + 1;
%		end
%	end
%end
% 
% Test
%functionalIdiomAC_2 - functionalIdiomAC
