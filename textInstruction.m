function textInstruction(initSetting, experimentPars, experimentFont, cfsPars)
	% Show instruction text

	%global resp
	experimentFont.textSize = experimentFont.textSizeInstruction;
	%experimentFont.textSize = experimentFont.textSizeIBI;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	c_text = textInstructionList;
	experimentFont.textOffSet = experimentFont.textInstructionOffSet;
	DrawFormattedText(initSetting.windowPtr, c_text.instruction{1}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]


	drawFixPointCFS(initSetting, experimentPars, cfsPars);
	drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
	Screen('Flip', initSetting.windowPtr);
	KbQueueWait;


	% Instruction practice1
	DrawFormattedText(initSetting.windowPtr, c_text.instruction{2}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	Screen('Flip', initSetting.windowPtr);
	KbQueueWait;


	%Mondrian demo
	tmpCount = 0; % 0 prepare frame
	while tmpCount < 30, % 1/10 * 30 = 3 sec
		DrawFormattedText(initSetting.windowPtr, c_text.instruction{3}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
		drawBiMondrians(initSetting, experimentPars, cfsPars);
		drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
		if tmpCount == 0,
			duration = [];
		else,
			duration = initSetting.sot + cfsPars.mondFlashDur - initSetting.ifi*0.5;
		end;
		[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, duration); %duration - 0.5*initSetting.ifi
		tmpCount = tmpCount + 1;
	end;
	DrawFormattedText(initSetting.windowPtr, c_text.instruction{4}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, duration); % 30th frame
	KbQueueWait;


	%Idiom Demo
	nCharacters = experimentPars.nCharacters; %how many characters in a idiom
	flashCount = 0;
	i = 1;
	for j = 0:nCharacters,
		if j == 0,
			DrawFormattedText(initSetting.windowPtr, c_text.instruction{5}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
			drawFixPointCFS(initSetting, experimentPars, cfsPars);
			drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
			if i == 1,
				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr);
			else,
				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5);
			end;
			experimentPars.duration = experimentPars.durationFixP;
			j = j + 1;
		else,
			experimentFont.textSize = experimentFont.textSizeSti;
			Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
			%drawFixPointCFS(initSetting, experimentPars, cfsPars);
			drawHolderFrameCfs(initSetting, experimentPars, cfsPars);

			Screen('DrawText', initSetting.windowPtr, c_text.instruction{6}(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerNDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
			Screen('DrawText', initSetting.windowPtr, c_text.instruction{6}(i,j), cfsPars.centerDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
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

	experimentFont.textSize = experimentFont.textSizeInstruction;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	DrawFormattedText(initSetting.windowPtr, c_text.instruction{7}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi
	KbQueueWait;

	
	% Instruction practice2; for run
	DrawFormattedText(initSetting.windowPtr, c_text.instruction{8}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]

	% For pretest only
	%DrawFormattedText(initSetting.windowPtr, c_text.contrast{2}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]

	Screen('Flip', initSetting.windowPtr);
	KbQueueWait;
