function contrastBlock(initSetting, experimentPars, cfsPars, idiomList, experimentFont)
	global resp g;
	% Set experiment idiom trial,
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	%k = 1; global lTiming llTiming;

	for i=1:experimentPars.nContrastTrialInBolck,
		nCharacters = experimentPars.nCharacters; %how many characters in a idiom
		g.mondCount = 0;
		flashCount = 0;
		j = 0;
		while j < nCharacters + 1,
			if j == 0,
				drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				if i == 1, %flip first frame
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr);
				else,%inherit previous tvbl
					[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5);
				end;
				experimentPars.duration = experimentPars.durationFixP;
				j = j + 1;
			else,
				drawFixMondrians(initSetting, experimentPars, cfsPars);

				% Band filter
				%if resp.textContrastState < 0.5, resp.textContrastState = 0.5; end;
				if resp.textContrastState < experimentPars.contrastHighpass, resp.textContrastState = experimentPars.contrastHighpass; end;
				if resp.textContrastState > experimentPars.contrastLowpass, resp.textContrastState = experimentPars.contrastLowpass; end;

				experimentFont.textColor = [repmat(initSetting.black, 1, 3), 255*resp.textContrastState];
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
	%flip blank
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi

	textIBIContrast(initSetting, experimentPars, experimentFont, cfsPars);

	resp.contrast{resp.iBlock} = getResponseMri(experimentPars);

	% Recording contrast state
	resp.contrast{resp.iBlock}.textContrastState = resp.textContrastState;


	% Recording response
	resp.contrast{resp.iBlock}.iBlock = resp.iBlock;


	% Implement contrast adjusting
	if experimentPars.mriHook,
		if resp.contrast{resp.iBlock}.keyCodeMri(1) == experimentPars.downContrastSignal && any(resp.downContrastSignalCount + 1),
			resp.contrastDownContrastSignalCount = resp.contrastDownContrastSignalCount + 1;
			%resp.textContrastState = resp.textContrastState - experimentPars.contrastDegrading; % degrading
			resp.textContrastState = resp.textContrastState*experimentPars.contrastDegrading; % degrading
			g.contrastFlagTmp = 0;
		elseif resp.contrast{resp.iBlock}.keyCodeMri(1) == experimentPars.upContrastSignal && any(resp.downContrastSignalCount + 1),
			if resp.iBlock > 1 && (resp.contrast{resp.iBlock}.keyCodeMri(1) + resp.contrast{resp.iBlock - 1}.keyCodeMri(1))/2 == experimentPars.upContrastSignal,
				resp.contrastUpContrastSignalCount = resp.contrastUpContrastSignalCount + 1;
				%resp.textContrastState = resp.textContrastState + experimentPars.contrastUpgrading; % upgrading
				resp.textContrastState = resp.textContrastState*experimentPars.contrastUpgrading; % upgrading
				g.contrastFlagTmp = 1;
			end;
		end;

	else, % if not connect to MRI
		if resp.contrast{resp.iBlock}.keyCode(1) == experimentPars.downContrastSignal && any(resp.downContrastSignalCount + 1),
			resp.contrastDownContrastSignalCount = resp.contrastDownContrastSignalCount + 1;
			%resp.textContrastState = resp.textContrastState - experimentPars.contrastDegrading; % degrading
			resp.textContrastState = resp.textContrastState*experimentPars.contrastDegrading; % degrading
			g.contrastFlagTmp = 0;
		elseif resp.contrast{resp.iBlock}.keyCode(1) == experimentPars.upContrastSignal && any(resp.downContrastSignalCount + 1),

			% 2 Up 1 down implementation
			if resp.iBlock > 1 && (resp.contrast{resp.iBlock}.keyCode(1) + resp.contrast{resp.iBlock - 1}.keyCode(1))/2 == experimentPars.upContrastSignal,
				resp.contrastUpContrastSignalCount = resp.contrastUpContrastSignalCount + 1;
				%resp.textContrastState = resp.textContrastState + experimentPars.contrastUpgrading; % upgrading
				resp.textContrastState = resp.textContrastState*experimentPars.contrastUpgrading; % upgrading
				g.contrastFlagTmp = 1;
			end;
		end;
	end;
	%resp.contrast{resp.iBlock}.iBlockRepe = resp.iBlockRepe;
	%resp.contrast{resp.iBlock}.blockSeq = resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4));
	%resp.contrast{resp.iBlock}.characterSeq = resp.characterSeq(resp.iRun, resp.blockSeq{resp.iRun}(resp.iBlockRepe, 1 + rem((resp.iBlock - 1), 4)));
	%resp.iBlock = resp.iBlock + 1;
