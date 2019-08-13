function idiomFunctionalROI(initSetting, experimentPars, cfsPars, idiomList, experimentFont)
	global resp g
	% Set experiment idiom trial,
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	%k = 1; global lTiming llTiming; %for timing test

	resp.functional{resp.iBlock}.bStamp = GetSecs; % Recording block time stamp

	% Synchronizing MRI trigger
	if experimentPars.mriHook,
		while true, %head %recording trigger time

			g.triggerCounter = 1; % Callback func trigger

			if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
				keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
				if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
					tmp = GetSecs;
					resp.functional{resp.iBlock}.tbStamp = tmp; % Recording trigger time stamp (block-wise)

					%resp.functional{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
					%g.tCount = g.tCount + 1;
					break;
				end;
			end;

			% Escape
			[pressed, firstPressT] = KbQueueCheck; %check if any key was pressed.
			escapeKey(firstPressT);

		end;
	else,
		%g.triggerCounter = 1; % If experimentPars.mriHook doesn't initiate, then set value to 0;
	end;


	for i=1:experimentPars.nTrialInBolck,
		nCharacters = experimentPars.nCharacters; %how many characters in a idiom
		flashCount = 0;
		for j = 0:nCharacters,
			if j == 0,
				drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				if i == 1,
					%getTrigger %here
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr);

					resp.functional{resp.iBlock}.blockSot = initSetting.sot; % Recording block time stamp
					resp.functional{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				else,
					%getTrigger %here
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5);
					resp.functional{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				end;
				experimentPars.duration = experimentPars.durationFixP;
				%j = j + 1;
			else,
				%drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);

				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerNDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				Screen('DrawingFinished', initSetting.windowPtr);
				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi
				if flashCount == 0, trialStartTime = initSetting.sot; end;

				% Escape
				[pressed, firstPressT] = KbQueueCheck; %check if any key was pressed.
				escapeKey(firstPressT);

				%% time test
				%lTiming(k) = initSetting.tvbl;
				%llTiming(k) = initSetting.sot;
				%k = k + 1;
				experimentPars.duration = experimentPars.durationCh;
			end;
		end;
	end;
	Screen('DrawingFinished', initSetting.windowPtr);
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi


	resp.functional{resp.iBlock}.stimuliEndStamp = initSetting.sot; % Recording block-wise stimuli end time stamp


	% Synchronizing MRI trigger
	if experimentPars.mriHook,

		% Empty BytesAvailable
		keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');

		while true, %head %recording trigger time

			g.triggerCounter = 1; % Callback func trigger

			if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
				keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
				if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
					tmp = GetSecs;
					resp.functional{resp.iBlock}.tStimuliEndStamp = tmp; % Recording trigger time stamp (block-wise)

					%resp.functional{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
					%g.tCount = g.tCount + 1;
					break;
				end;
			end;

			% Escape
			[pressed, firstPressT] = KbQueueCheck; %check if any key was pressed.
			escapeKey(firstPressT);

		end;
	else,
		%g.triggerCounter = 1; % If experimentPars.mriHook doesn't initiate, then set value to 0;
	end;


	resp.functional{resp.iBlock}.blockSeq = resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4));

	% Switch list for in-block idiom or out-block idiom
	% Sample space for drawing
	%idiomSampleSpaceIndx = [1, 2, (experimentPars.nTrialInBolck - 1), experimentPars.nTrialInBolck];
	idiomSampleSpaceIndx = [1, experimentPars.nTrialInBolck];


	if g.functionIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(resp.iBlockRepe) == 1,
		g.testIdiom = idiomList(randsample(idiomSampleSpaceIndx, 1), 1:nCharacters);
		resp.functional{resp.iBlock}.testIdiom = g.testIdiom;
		resp.functional{resp.iBlock}.testIdiomCon = 1;
	elseif g.functionIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(resp.iBlockRepe) == 0,
		if resp.functional{resp.iBlock}.blockSeq == 1 | resp.functional{resp.iBlock}.blockSeq == 3,
			g.testIdiom = g.testIdiomNovel(... % Recalibrate
				(experimentPars.nCondition*experimentPars.nBolckRepetitionInRun*experimentPars.runs)/2 ...
				+ g.novelFuncShufList(g.novelShufCounter), 1:nCharacters);
		elseif resp.functional{resp.iBlock}.blockSeq == 2 | resp.functional{resp.iBlock}.blockSeq == 4,
			g.testIdiom = g.testIdiomNovelRandom(... % Recalibrate
				(experimentPars.nCondition*experimentPars.nBolckRepetitionInRun*experimentPars.runs)/2 ...
				+ g.novelFuncShufList(g.novelShufCounter), 1:nCharacters);
		end;


		resp.functional{resp.iBlock}.testIdiom = g.testIdiom;
		resp.functional{resp.iBlock}.testIdiomCon = 0;
		g.novelShufCounter = g.novelShufCounter + 1;
	end;


	textIBI(initSetting, experimentPars, experimentFont, cfsPars);
	experimentPars.durIbi = experimentPars.durIbiFroi;
	resp.functional{resp.iBlock}.idiom = getResponseMri(experimentPars);
	resp.functional{resp.iBlock}.iBlock = resp.iBlock;
	resp.functional{resp.iBlock}.iBlockRepe = resp.iBlockRepe;
	resp.functional{resp.iBlock}.characterSeq = resp.characterSeq(resp.iRun, resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4)));
	resp.functional{resp.iBlock}.idiomList = idiomList;

	% If the MRItrigger is on, then start recording the trigger on each trial
	%if g.timeStampMx(1, g.triggerCounter),
	if g.timeStampMx(1, 1),
		%resp.main{resp.iBlock}.triggerStamp = g.timeStampMx(g.triggerCounter);
		resp.main{resp.iBlock}.triggerStamp = g.timeStampMx;
	end;

	resp.iBlock = resp.iBlock + 1;
