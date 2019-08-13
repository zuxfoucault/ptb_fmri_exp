function idiomImposeBlock(initSetting, experimentPars, cfsPars, idiomList, experimentFont)
	global resp g
	% Set experiment idiom trial,
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);

	resp.main{resp.iBlock}.bStamp = GetSecs; % Recording block time stamp

	%g.tCount = 1;

	% Synchronizing MRI trigger
	if experimentPars.mriHook,
		while true,

			g.triggerCounter = 1;

			if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
				keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
				if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
					tmp = GetSecs;
					resp.main{resp.iBlock}.tbStamp = tmp; % Recording trigger time stamp (block-wise)

					%resp.main{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
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
		g.mondCount = 0;
		flashCount = 0;
		j = 0;
		while j < nCharacters + 1,
			if j == 0,
				drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				if i == 1,
					%getTrigger %here
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr);

					resp.main{resp.iBlock}.blockSot = initSetting.sot; % Recording block time stamp
					resp.main{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				else,
					%getTrigger %here
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5);
					resp.main{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				end;
				experimentPars.duration = experimentPars.durationFixP;
				j = j + 1;
			else,
				drawFixBiMondrians(initSetting, experimentPars, cfsPars);
				if resp.textContrastState <= experimentPars.contrastHighpass, resp.textContrastState = experimentPars.contrastHighpass; end; % For Windows
				if resp.textContrastState >= experimentPars.contrastLowpass, resp.textContrastState = experimentPars.contrastLowpass; end;
				resp.main{resp.iBlock}.textContrastState = experimentFont.imposeContrast; % Keep fix to 0.5
				experimentFont.textColor = [repmat(initSetting.black, 1, 3), 255*experimentFont.imposeContrast];
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerNDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				Screen('DrawingFinished', initSetting.windowPtr);

				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi
				if flashCount == 0, trialStartTime = initSetting.sot; end;


				% Escape
				[pressed, firstPressT] = KbQueueCheck; %check if any key was pressed.
				escapeKey(firstPressT);


				if (experimentPars.durationCh - cfsPars.mondFlashDur*flashCount)/cfsPars.mondFlashDur >= 1
					experimentPars.duration = cfsPars.mondFlashDur;
					flashCount = flashCount + 1;
				else,
					experimentPars.duration = mod(experimentPars.durationCh, cfsPars.mondFlashDur);
					flashCount = 0;
					j = j + 1;
				end;
			end;
		end;
	end;
	Screen('DrawingFinished', initSetting.windowPtr);
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi


	resp.main{resp.iBlock}.stimuliEndStamp = initSetting.sot; % Recording block-wise stimuli end time stamp


	% Synchronizing MRI trigger
	if experimentPars.mriHook,

		% Empty BytesAvailable
		keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');

		while true,

			g.triggerCounter = 1;

			if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
				keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
				if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
					tmp = GetSecs;
					resp.main{resp.iBlock}.tStimuliEndStamp = tmp; % Recording trigger time stamp (block-wise)

					%resp.main{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
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


	textIBIContrast(initSetting, experimentPars, experimentFont, cfsPars);
	resp.main{resp.iBlock}.character = getResponseMri(experimentPars);


	%here set sudo-random list to decide idiom source

	resp.main{resp.iBlock}.blockSeq = resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + ...
		rem((resp.iBlock - 1), 4));


	% Sample space for drawing
	%idiomSampleSpaceIndx = [1, 2, (experimentPars.nTrialInBolck - 1), experimentPars.nTrialInBolck];
	idiomSampleSpaceIndx = [1, experimentPars.nTrialInBolck];

	%if g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(mod(resp.iBlockRepe, 2) + 1) == 1, % Wrong
	if g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(resp.iBlockRepe) == 1,
		g.testIdiom = idiomList(randsample(idiomSampleSpaceIndx, 1), 1:nCharacters);
		resp.main{resp.iBlock}.testIdiom = g.testIdiom;
		resp.main{resp.iBlock}.testIdiomCon = 1;
	%elseif g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(mod(resp.iBlockRepe, 2) + 1) == 0,
	elseif g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(resp.iBlockRepe) == 0,
		if resp.main{resp.iBlock}.blockSeq == 3,
			g.testIdiom = g.testIdiomNovel(g.novelReguShufList(g.novelShufCounter), 1:nCharacters);
		elseif resp.main{resp.iBlock}.blockSeq == 4,
			g.testIdiom = g.testIdiomNovelRandom(g.novelReguShufList(g.novelShufCounter), 1:nCharacters);
		end;
		resp.main{resp.iBlock}.testIdiom = g.testIdiom;
		resp.main{resp.iBlock}.testIdiomCon = 0;
		g.novelShufCounter = g.novelShufCounter + 1;
	end;


	textIBI(initSetting, experimentPars, experimentFont, cfsPars);
	resp.main{resp.iBlock}.idiom = getResponseMri(experimentPars);

	resp.main{resp.iBlock}.iBlock = resp.iBlock;
	resp.main{resp.iBlock}.iRun = resp.iRun;
	resp.main{resp.iBlock}.iBlockRepe = resp.iBlockRepe;
	resp.main{resp.iBlock}.characterSeq = resp.characterSeq(resp.iRun, resp.blockSeq{resp.iRun}...
		(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4)));
	resp.main{resp.iBlock}.idiomList = idiomList;

	% If the MRItrigger is on, then start recording the trigger on each trial
	%if g.timeStampMx(1, g.triggerCounter),
	if g.timeStampMx(1, 1),
		%resp.main{resp.iBlock}.triggerStamp = g.timeStampMx(g.triggerCounter);
		resp.main{resp.iBlock}.triggerStamp = g.timeStampMx;
	end;


	resp.iBlock = resp.iBlock + 1;
