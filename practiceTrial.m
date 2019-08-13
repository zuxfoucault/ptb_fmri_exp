function practiceTrial(initSetting, experimentPars, experimentFont, cfsPars)
	% Bring practice trial

	global resp


	c_text = textPracticeList;

	[r, dump] = size(c_text.trial);

	blockSeq = Shuffle(1:r); % Column: sequence of condition in each repetition. List number same as switch-case number. Row: each repetition.

	resp.iBlock = 1; % Practice
	trialSequency = Shuffle(1:2);
	i = 1;
	while i <= 2,
		%switch rem(blockSeq(resp.iBlock),2),
		switch rem(trialSequency(resp.iBlock),2), 
			case 1,
				%blockSeq(iBlockRepe, 1 + rem((resp.iBlock - 1), experimentPars.nCondition)); %for check
				idiomL = c_text.trial(1:experimentPars.nTrialInBolckPrac,:);
				idiomBlockPractice(initSetting, experimentPars, cfsPars, idiomL, experimentFont);
				i = i + 1;
			case 0,
				idiomL = c_text.trial((experimentPars.nTrialInBolckPrac+1):experimentPars.nTrialInBolckPrac*2,:);
				idiomImposeBlockPrac(initSetting, experimentPars, cfsPars, idiomL, experimentFont);
				i = i + 1;
		end;
	end;


	experimentFont.textSize = experimentFont.textSizeInstruction;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	c_text = textInstructionList;
	experimentFont.textOffSet = experimentFont.textInstructionOffSet;


	% Instruction to set contrast level
	DrawFormattedText(initSetting.windowPtr, c_text.contrast{2}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
	Screen('Flip', initSetting.windowPtr);
	KbQueueWait;
