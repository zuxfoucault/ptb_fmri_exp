function [experimentPars cfsPars] = adjustMondrianFrame(initSetting, experimentPars, experimentFont, cfsPars)
	global g; % resp;
	experimentFont.textSize = experimentFont.textSizeInstruction;
	%experimentFont.textSize = experimentFont.textSizeIBI;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	c_text = textInstructionList;
	experimentFont.textOffSet = experimentFont.textInstructionOffSet;
	DrawFormattedText(initSetting.windowPtr, 'Adjust Frame Position', cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]

	drawFixPointCFS(initSetting, experimentPars, cfsPars);
	drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
	Screen('Flip', initSetting.windowPtr);

	KbQueueFlush;

	shift = 1; % Value for adjust mondrian frame position

	keyCode = 1;

	while keyCode ~= KbName('Space'),

		if experimentPars.responsetype,
			[pressed, firstPressT] = mriButtonCheck(experimentPars);
			escapeKey(firstPressT);

			if pressed,
				firstPressT(find(firstPressT==0)) = NaN; %little trick to get rid of 0s
				[pressTime keyCode] = min(firstPressT); % gets the RT of the first key-press and its ID

				switch keyCode,
					case 51,
						experimentPars.center(1) = experimentPars.center(1) - shift;
						cfsPars.centerDomin(1) = cfsPars.centerDomin(1) - shift;
						%cfsPars.centerNDomin(1) = cfsPars.centerNDomin(1) - shift;
					case 52,
						experimentPars.center(1) = experimentPars.center(1) + shift;
						cfsPars.centerDomin(1) = cfsPars.centerDomin(1) + shift;
						%cfsPars.centerNDomin(1) = cfsPars.centerNDomin(1) + shift;
				end;
			end;
		end;

		[pressed, firstPressT] = KbQueueCheck; %check if any key was pressed.
		escapeKey(firstPressT);

		if pressed,
			firstPressT(find(firstPressT==0)) = NaN; %little trick to get rid of 0s
			[pressTime keyCode] = min(firstPressT); % gets the RT of the first key-press and its ID

			switch keyCode,
				case KbName('LeftArrow')
					experimentPars.center(1) = experimentPars.center(1) - shift;
					cfsPars.centerDomin(1) = cfsPars.centerDomin(1) - shift;
					%cfsPars.centerNDomin(1) = cfsPars.centerNDomin(1) - shift;
				case KbName('RightArrow')
					experimentPars.center(1) = experimentPars.center(1) + shift;
					cfsPars.centerDomin(1) = cfsPars.centerDomin(1) + shift;
					%cfsPars.centerNDomin(1) = cfsPars.centerNDomin(1) + shift;
			end;
		end;
		%cfsPars = setCfsPars(initSetting, experimentPars);
		drawFixPointCFS(initSetting, experimentPars, cfsPars);
		drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
		DrawFormattedText(initSetting.windowPtr, 'Adjust Frame Position', cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]
		Screen('Flip', initSetting.windowPtr);
		WaitSecs(0.1);
	end;
