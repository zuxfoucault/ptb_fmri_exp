% Make selected text matrix for out source 
function makeIdiomNovelPretest(experimentPars)

global g

c_text = textOutSourcePretest; % length(c_text) = 508
bufferLength = 5;


nIdiomNovelRegu = (experimentPars.nCondition*experimentPars.nBolckRepetitionInRun*experimentPars.runs)/2 + bufferLength*2; % default=64/2; to fix unknown reason for index out of bound, add additional 20 for buffer
nIdiomNovelReguRandom = nIdiomNovelRegu;

nIdiomNovelFunc = (experimentPars.nCondition*experimentPars.nBolckRepetitionInRun)/2; % default=16/2
nIdiomNovelFuncRandom = nIdiomNovelFunc;

%% Fix the out source db
%if exist('idiomOutSouce.mat'),
%	load('idiomOutSouce.mat', 'sampleIndex')
%	if length(sampleIndex) ~= (nIdiomNovelRegu + nIdiomNovelFunc)*2,
%		% Double the size because of the implementing of random novel list
%		sampleIndex = randsample(length(c_text), (nIdiomNovelRegu + nIdiomNovelFunc)*2);
%		save('idiomOutSouce.mat', 'sampleIndex') %here
%		disp('update idiomOutSouce due to length(sampleIndex) not fit')
%	end;
%else,
%	sampleIndex = randsample(length(c_text), (nIdiomNovelRegu + nIdiomNovelFunc)*2);
%	save('idiomOutSouce.mat', 'sampleIndex')
%	disp('update idiomOutSouce because of missing idiomOutSouce.mat')
%end;


% Fix the out source db
if exist('idiomOutSoucePretest.mat'),
	load('idiomOutSoucePretest.mat', 'sampleIndex')
	if length(sampleIndex) ~= (nIdiomNovelRegu + nIdiomNovelFunc + bufferLength)*2,
		% Double the size because of the implementing of random novel list
		sampleIndex = randsample(length(c_text), (nIdiomNovelRegu + nIdiomNovelFunc)*2);
		save('idiomOutSoucePretest.mat', 'sampleIndex') %here
		disp('update idiomOutSoucePretest due to length(sampleIndex) not fit')
	end;
else,
	sampleIndex = randsample(length(c_text), (nIdiomNovelRegu + nIdiomNovelFunc)*2);
	save('idiomOutSoucePretest.mat', 'sampleIndex')
	disp('update idiomOutSouce because of missing idiomOutSoucePretest.mat')
end;


% Novel idiom list
g.testIdiomNovel = c_text(sampleIndex(1:nIdiomNovelRegu + nIdiomNovelFunc), :);
testIdiomNovelRandom = c_text(sampleIndex(nIdiomNovelRegu + nIdiomNovelFunc + 1:end), :);
%length(g.testIdiomNovel) % Value == 80 for formal experiment

[r c] = size(testIdiomNovelRandom);
rIndex = zeros(r, c);
list = zeros(r, c);
for i = 1:c, %shuffled by each row
	rIndex(:, i) = randperm(r);
	list(:, i) = testIdiomNovelRandom(rIndex(:, i), i);
end;
cIndex = randperm(c); %shuffle columns
saladList = list(:, cIndex);

g.testIdiomNovelRandom = saladList;


% Shuffle list
g.novelReguShufList = Shuffle(1:nIdiomNovelRegu);
g.novelFuncShufList = Shuffle(1:nIdiomNovelFunc);
g.novelShufCounter = 1;
