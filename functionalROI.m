function functionalROI(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont)
	global resp g

	resp.iBlock = 1; % Recalibrate for Fuctional ROI session

	resp.iBlockRepe = 1;

	g.session = 4; % Recording

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
			};
		resp.functionIdiomCondition{resp.iRun} = g.functionIdiomCondition{resp.iRun};

		[dump blockSeq] = latsq(experimentPars.nCondition); % Column: sequence of condition in each repetition. List number same as switch-case number. Row: each repetition.
		resp.blockSeq{iRun} = blockSeq;
		resp.blockSeqFunctional{iRun} = blockSeq; % For record
		for iBlockRepe = 1:experimentPars.nBolckRepetitionInRun,
			resp.iBlockRepe = iBlockRepe;
			while resp.iBlock <= iBlockRepe*experimentPars.nCondition
				switch blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)),
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
			end;
		end;
	end;
