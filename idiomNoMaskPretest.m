function idiomNoMaskPretest(initSetting, experimentPars, cfsPars, idiomList, experimentFont)

	% Inherit from idiomFunctionalROI.m

	global resp g
	% Set experiment idiom trial,
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	%k = 1; global lTiming llTiming; %for timing test

	resp.pretest{resp.iBlock}.bStamp = GetSecs; % Recording block time stamp

	g.tCount = 1;

	% Synchronizing MRI trigger
	if experimentPars.mriHook,
		while true, %head %recording trigger time

			if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
				keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
				if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
					tmp = GetSecs;
					resp.pretest{resp.iBlock}.tbStamp = tmp; % Recording trigger time stamp (block-wise)

					%resp.pretest{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
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
		flashCount = 0;
		for j = 0:nCharacters,
			if j == 0,
				drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				if i == 1,
					%getTrigger %here
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr);

					resp.pretest{resp.iBlock}.blockSot = initSetting.sot; % Recording block time stamp
					resp.pretest{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				else,
					%getTrigger %here
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5);
					resp.pretest{resp.iBlock}.trialSot(i) = initSetting.sot; % Recording trial time stamp
				end;
				experimentPars.duration = experimentPars.durationFixP;
				j = j + 1;
			else,
				%drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);

				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerNDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				Screen('DrawingFinished', initSetting.windowPtr);
				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi
				if flashCount == 0, trialStartTime = initSetting.sot; end;
				%% time test
				%lTiming(k) = initSetting.tvbl;
				%llTiming(k) = initSetting.sot;
				%k = k + 1;
				experimentPars.duration = experimentPars.durationCh;
			end;
		end;
	end;
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi


	resp.pretest{resp.iBlock}.stimuliEndStamp = initSetting.sot; % Recording block-wise stimuli end time stamp

	% Switch list for in-block idiom or out-block idiom

	resp.pretest{resp.iBlock}.blockSeq = resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4));


	% Sample space for drawing
	%idiomSampleSpaceIndx = [1, 2, (experimentPars.nTrialInBolck - 1), experimentPars.nTrialInBolck];
	idiomSampleSpaceIndx = [1, experimentPars.nTrialInBolck];

	% For pretest
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
	experimentPars.durIbi = experimentPars.durIbiFroi;
	resp.pretest{resp.iBlock}.idiom = getResponseMri(experimentPars);
	resp.pretest{resp.iBlock}.iBlock = resp.iBlock;
	resp.pretest{resp.iBlock}.iBlockRepe = resp.iBlockRepe;
	resp.pretest{resp.iBlock}.characterSeq = resp.characterSeq(resp.iRun, resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4)));
	resp.pretest{resp.iBlock}.idiomList = idiomList;

	% If the MRItrigger is on, then start recording the trigger on each trial
	%if g.timeStampMx(1, g.triggerCounter),
	if g.timeStampMx(1, 1),
		%resp.main{resp.iBlock}.triggerStamp = g.timeStampMx(g.triggerCounter);
		resp.main{resp.iBlock}.triggerStamp = g.timeStampMx;
	end;

	resp.iBlock = resp.iBlock + 1;
