function regularSession(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont)

	global resp g
	resp.iBlock = 1; % Regular session index

	g.session = 4;

	[dump characterSeq] = latsq(experimentPars.nCondition);
	% Column: sequence of list in which condition. #1 in the list refer to 1:40 idioms; 2 to 41:80 ... Row: each run.
	resp.characterSeq = characterSeq;

	g.novelShufCounter = 1; % Reset the novelShufCounter for regular session


	for iRun = 1:experimentPars.runs, %runs; experimentPars.runs
		resp.iRun = iRun;
		[dump blockSeq] = latsq(experimentPars.nCondition);
		% Column: sequence of condition in each repetition. List number same as switch-case number. Row: each repetition.
		resp.blockSeq{iRun} = blockSeq;
		resp.blockSeqRegular{iRun} = blockSeq; % For record


		% Switch for in-block idiom or out-block idiom in regular session
		idiomSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		idiomSaladSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		idiomImpoSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		idiomSaladImpoSeq = Shuffle(repmat([0,1],1,experimentPars.nBolckRepetitionInRun/2));
		g.testIdiomCondition{iRun} = {idiomSeq idiomSaladSeq idiomImpoSeq idiomSaladImpoSeq};
		resp.testIdiomCondition{iRun} = g.testIdiomCondition{iRun};


		for iBlockRepe = 1:experimentPars.nBolckRepetitionInRun,

			resp.iBlockRepe = iBlockRepe;

			while resp.iBlock <= iBlockRepe*experimentPars.nCondition*resp.iRun
				switch blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)),
					%switch 1 %test contrast degrading
					case 1,
						%blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)); %for check
						%characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)))
						idiomL = idiomListShuffled.idiom((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);

						idiomBlock(initSetting, experimentPars, cfsPars, idiomL, experimentFont);

					case 2,
						idiomS = idiomListShuffled.saladList((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomBlock(initSetting, experimentPars, cfsPars, idiomS, experimentFont);%salad

					case 3,
						idiomL = idiomListShuffled.idiom((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomImposeBlock(initSetting, experimentPars, cfsPars, idiomL, experimentFont);

					case 4,
						idiomS = idiomListShuffled.saladList((characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + 1 + (iBlockRepe - 1)*experimentPars.nTrialInBolck:(characterSeq(iRun, blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition))) - 1)*experimentPars.nBolckRepetitionInRun*experimentPars.nTrialInBolck + iBlockRepe*experimentPars.nTrialInBolck,:);
						idiomImposeBlock(initSetting, experimentPars, cfsPars, idiomS, experimentFont);

					otherwise,
						disp('Switch-case error in regular session!');
				end;
			end;
		end;


		% How long to rest 
		%restStart = GetSecs;
		%tmp = 0;
		%restDuration = 60; % Resting duration
		%while GetSecs <= restStart + restDuration,
		%	%tmp = GetSecs; %here
		%	pause(1)
		%end;
		Screen('Flip', initSetting.windowPtr);
		%Screen('DrawText', initSetting.windowPtr, 'Ready?', cfsPars.centerNDomin(1) - experimentFont.toCenter, cfsPars.centerNDomin(2) - experimentFont.toCenter, experimentFont.textColor);
		if iRun < experimentPars.runs
			Screen('TextSize', initSetting.windowPtr, experimentFont.textSizeIBI);
			DrawFormattedText(initSetting.windowPtr, 'Ready?', cfsPars.centerDomin(1) - ...
				experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + ...
				experimentFont.testIdiomOffSet, 0, 40, [], [], 1.5, []);
			Screen('Flip', initSetting.windowPtr);
			KbQueueWait; %here for formal experiment IRI
		end;
	end;

	% Then prepare for functional ROI
