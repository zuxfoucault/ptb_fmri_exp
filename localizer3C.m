function localizer3C(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont)
	% Inherited from functionalROI.m

	global resp g

	resp.iBlock = 1; % Recalibrate for Fuctional ROI session

	resp.iBlockRepe = 1;

	g.tCount = 1;

	g.session = 3; % Recording

	[dump characterSeq] = latsq(experimentPars.nCondition); % Column: sequence of list in which condition. #1 in the list refer to 1:40 idioms; 2 to 41:80 ... Row: each run.
	resp.characterSeq = characterSeq;

	experimentPars.runs = experimentPars.runsROI; %for functional ROI

	g.novelShufCounter = 1; % Reset the novelShufCounter for functional ROI session


	for iRun = 1:experimentPars.runs, %runs; experimentPars.runs
		resp.iRun = iRun;

		% Switch for in-block idiom or out-block idiom in functionROI session
		g.functionIdiomCondition{resp.iRun} = {...
			Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2)) ...
			Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2)) ...
			Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2)) ...
			Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2)) ...
			%Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun)) ...
			%Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun)) ...
			};
		resp.functionIdiomCondition{resp.iRun} = g.functionIdiomCondition{resp.iRun};


		%if resp.localizerCondition == 0,
		%	blockSeq = repmat([1:4], experimentPars.nCondition, 1);
		%elseif resp.localizerCondition == 1,
		%	blockSeq = repmat(fliplr([1:4]), experimentPars.nCondition, 1);
		%end;

		[dump blockSeq] = latsq(experimentPars.nCondition); % Column: sequence of condition in each repetition. List number same as switch-case number. Row: each repetition.

		% Swap for ISFSIF sequence
		if rem(blockSeq(1, 1),2) ~= rem(blockSeq(1, 2),2),
			tmpM = blockSeq([1, experimentPars.nCondition], [1 2]);
			blockSeq([1, experimentPars.nCondition], [1 2]) = tmpM(:, [2 1]);
		elseif rem(blockSeq(1, 1),2) == rem(blockSeq(1, 2),2),
			tmpM = blockSeq(:, [2 3]);
			blockSeq(:, [2 3]) = tmpM(:, [2 1]);
			tmpM = blockSeq([1, experimentPars.nCondition], [1 2]);
			blockSeq([1, experimentPars.nCondition], [1 2]) = tmpM(:, [2 1]);
		end;

		resp.blockSeq{iRun} = blockSeq; % blcckSeq is needed for characterSeq
		resp.blockSeqFunctional{iRun} = blockSeq; % For record


		for iBlockRepe = 1:experimentPars.nBolckRepetitionInRun,
			resp.iBlockRepe = iBlockRepe;
			while resp.iBlock <= iBlockRepe*experimentPars.nCondition
				switch blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)),
					%switch blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)),
					%switch 1 %test contrast degrading
					case 1,
						%blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)); %for check
						%characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)))
						idiomL = idiomListShuffled.idiom((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomFunctionalROI(initSetting, experimentPars, cfsPars, idiomL, experimentFont);

					case 2,
						idiomS = idiomListShuffled.saladList((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomFunctionalROI(initSetting, experimentPars, cfsPars, idiomS, experimentFont);%salad

					case 3,
						idiomL = idiomListShuffled.idiom((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomFunctionalROI(initSetting, experimentPars, cfsPars, idiomL, experimentFont);

					case 4,
						idiomS = idiomListShuffled.saladList((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomFunctionalROI(initSetting, experimentPars, cfsPars, idiomS, experimentFont);
				end;

				% Fixation baseline
				if rem(resp.iBlock - 1, 2) == 0,
					fixationBaseline(initSetting, experimentPars, cfsPars)
				end;
			end;
		end;
	end;


	% Prepare for next run
	experimentFont.textSize = experimentFont.textSizeInstruction;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	c_text = textInstructionList;
	experimentFont.textOffSet = experimentFont.textInstructionOffSet;
	DrawFormattedText(initSetting.windowPtr, c_text.instruction{9}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	%DrawFormattedText(initSetting.windowPtr, 'Ready?', cfsPars.centerDomin(1) - ...
	%experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + ...
	%experimentFont.testIdiomOffSet, 0, 40, [], [], 1.5, []);
	Screen('Flip', initSetting.windowPtr);
	KbQueueWait; %here for formal experiment IRI

