function idiomBlockPretest(initSetting, experimentPars, cfsPars, idiomList, experimentFont)

	% Inherit from idiomBlock.m

	global resp g
	% Take 50% from idiomList
	% Set experiment idiom trial,
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	%k = 1; global lTiming llTiming;

	resp.pretest{resp.iBlock}.bStamp = GetSecs; % Recording block time stamp

	g.tCount = 1;

	% Synchronizing MRI trigger
	if experimentPars.mriHook,
		while true, %head %recording trigger time

			g.triggerCounter = 1; % Callback func trigger

			if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
				keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
				if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
					tmp = GetSecs;
					resp.main{resp.iBlock}.tbStamp = tmp; % Recording trigger time stamp (block-wise)

					resp.main{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
					g.tCount = g.tCount + 1;
					break;
				end;
			end;

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
				if i == 1, %flip first frame
					%getTrigger in trial based synchronizing %check
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr);

					resp.pretest{resp.iBlock}.blockSot = initSetting.sot; % Recording block time stamp
					resp.pretest{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp

				else,%inherit previous tvbl
					%getTrigger in trial based synchronizing %check
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5);
					resp.pretest{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				end;
				experimentPars.duration = experimentPars.durationFixP;
				j = j + 1;
			else,
				drawFixMondrians(initSetting, experimentPars, cfsPars);
				%if resp.textContrastState < 0.5, resp.textContrastState = 0.5; end; % For OSX
				if resp.textContrastState <= experimentPars.contrastHighpass, resp.textContrastState = experimentPars.contrastHighpass; end; % For Windows
				if resp.textContrastState >= experimentPars.contrastLowpass, resp.textContrastState = experimentPars.contrastLowpass; end;
				resp.pretest{resp.iBlock}.textContrastState = resp.textContrastState;
				experimentFont.textColor = [repmat(initSetting.black, 1, 3), 255*resp.textContrastState];
				%experimentFont.textColor = [repmat(initSetting.white, 1, 3), 255/2];%here 127
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerNDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				Screen('DrawingFinished', initSetting.windowPtr);

				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi
				if flashCount == 0, trialStartTime = initSetting.sot; end;

				% time test
				%lTiming(k) = initSetting.tvbl;
				%llTiming(k) = initSetting.sot;
				%k = k + 1;

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

	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi

	resp.pretest{resp.iBlock}.stimuliEndStamp = initSetting.sot; % Recording block-wise stimuli end time stamp

	textIBIContrast(initSetting, experimentPars, experimentFont, cfsPars);
	resp.pretest{resp.iBlock}.character = getResponseMri(experimentPars);

	% Feedback loop for stimuli contrast adjustment
	% Implement contrast adjusting
	if experimentPars.mriHook,
		if resp.pretest{resp.iBlock}.character.keyCodeMri(1) == experimentPars.downContrastSignal && any(resp.downContrastSignalCount + 1),
			resp.downContrastSignalCount = resp.contrastDownContrastSignalCount + 1;
			resp.textContrastState = resp.textContrastState*experimentPars.contrastDegrading; % degrading
		elseif resp.pretest{resp.iBlock}.character.keyCodeMri(1) == experimentPars.upContrastSignal && any(resp.downContrastSignalCount + 1),
			resp.downContrastSignalCount = resp.contrastUpContrastSignalCount + 1;
			%resp.textContrastState = resp.textContrastState*experimentPars.contrastUpgrading; % upgrading
		end;

	else, % if not connect to MRI

		if resp.pretest{resp.iBlock}.character.keyCode(1) == experimentPars.downContrastSignal && any(resp.downContrastSignalCount + 1),
			resp.downContrastSignalCount = resp.downContrastSignalCount + 1;
			resp.textContrastState = resp.textContrastState*experimentPars.contrastDegrading; % degrading

		elseif resp.pretest{resp.iBlock}.character.keyCode(1) == experimentPars.upContrastSignal && any(resp.upContrastSignalCount + 1),
			resp.upContrastSignalCount = resp.upContrastSignalCount + 1;
			%resp.textContrastState = resp.textContrastState*experimentPars.contrastUpgrading; % upgrading
		end;
	end;



	%tmp for development
	%g.testIdiom = idiomList(randsample(experimentPars.nTrialInBolck, 1),:);
	%here set sudo-random list to decide idiom source


	resp.pretest{resp.iBlock}.blockSeq = resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + ...
		rem((resp.iBlock - 1), 4));


	% Sample space for drawing
	%idiomSampleSpaceIndx = [1, 2, (experimentPars.nTrialInBolck - 1), experimentPars.nTrialInBolck];
	idiomSampleSpaceIndx = [1,  experimentPars.nTrialInBolck];

	%if g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(mod(resp.iBlockRepe, 2) + 1) == 1, % Wrong; before 20150911
	if g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(resp.iBlockRepe) == 1,
		g.testIdiom = idiomList(randsample(idiomSampleSpaceIndx, 1), 1:nCharacters);
		resp.pretest{resp.iBlock}.testIdiom = g.testIdiom;
		resp.pretest{resp.iBlock}.testIdiomCon = 1;

	%elseif g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(mod(resp.iBlockRepe, 2) + 1) == 0,
	elseif g.testIdiomCondition{resp.iRun}{resp.blockSeq{resp.iRun}(resp.iBlockRepe, (1 + mod(resp.iBlock - 1, 4)))}(resp.iBlockRepe) == 0,
		if resp.pretest{resp.iBlock}.blockSeq == 1,
			g.testIdiom = g.testIdiomNovel(g.novelReguShufList(g.novelShufCounter), 1:nCharacters);
		elseif resp.pretest{resp.iBlock}.blockSeq == 2,
			g.testIdiom = g.testIdiomNovelRandom(g.novelReguShufList(g.novelShufCounter), 1:nCharacters);
		end;
		resp.pretest{resp.iBlock}.testIdiom = g.testIdiom;
		resp.pretest{resp.iBlock}.testIdiomCon = 0;
		g.novelShufCounter = g.novelShufCounter + 1;
	end;

	textIBI(initSetting, experimentPars, experimentFont, cfsPars);
	resp.pretest{resp.iBlock}.idiom = getResponseMri(experimentPars);

	resp.pretest{resp.iBlock}.iBlock = resp.iBlock;
	resp.pretest{resp.iBlock}.iRun = resp.iRun;
	resp.pretest{resp.iBlock}.iBlockRepe = resp.iBlockRepe;
	resp.pretest{resp.iBlock}.characterSeq = resp.characterSeq(resp.iRun, resp.blockSeq{resp.iRun}...
		(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4)));
	resp.pretest{resp.iBlock}.idiomList = idiomList;

	% If the MRItrigger is on, then start recording the trigger on each trial
	%if g.timeStampMx(1, g.triggerCounter),
	if g.timeStampMx(1, 1),
		%resp.main{resp.iBlock}.triggerStamp = g.timeStampMx(g.triggerCounter);
		resp.main{resp.iBlock}.triggerStamp = g.timeStampMx;
	end;


	resp.iBlock = resp.iBlock + 1;
