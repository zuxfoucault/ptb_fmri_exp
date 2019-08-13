function idiomListShuffled = setIdiomListShuffled(idiomList, experimentPars)
	[r c] = size(idiomList); c = experimentPars.nCharacters; % nCharacter
	idiomListShuffled.idiomIndex = randperm(r);
	idiomListShuffled.idiom = idiomList(idiomListShuffled.idiomIndex, 1:c);
	idiomListShuffled.rIndex = zeros(r, c-1);
	idiomListShuffled.list = zeros(r, c-1);
	for i = 1:c, %shuffled by each row
		idiomListShuffled.rIndex(:, i) = randperm(r);
		idiomListShuffled.list(:, i) = idiomList(idiomListShuffled.rIndex(:, i), i);
	end;
	idiomListShuffled.cIndex = randperm(c); %shuffle columns
	idiomListShuffled.saladList = idiomListShuffled.list(:, idiomListShuffled.cIndex);

	% Comment out for pretest
	%idiomListShuffled.fifth = zeros(r/experimentPars.nCharacters, experimentPars.nCharacters);
	%for i = 1:r/experimentPars.nCharacters,
	%	idiomListShuffled.fifth(i, :) = idiomList(1 + (i-1)*experimentPars.nCharacters:i*experimentPars.nCharacters,5);
	%end;
	
	% New version contrast words
	contrastIdiomList = textOutSourcePretestIII;
	[r c] = size(contrastIdiomList);
	idiomListShuffled.rIndexContrast = randperm(r);
	idiomListShuffled.contrastIdiomList = contrastIdiomList(idiomListShuffled.rIndexContrast, :);
