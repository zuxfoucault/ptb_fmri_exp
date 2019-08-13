% Pretest for setting proper contrast level
function setContrastLevel(initSetting, experimentPars, cfsPars, idiomListShuffled, experimentFont)

	global resp g

	resp.iBlock = 1; % Initiation contrast trial
	resp.contrastDownContrastSignalCount = 0;
	resp.contrastUpContrastSignalCount = 0;
	resp.upContrastSignalCount = 0;
	resp.contrastStateRecording = zeros(1, 2);
	resp.contrastCeaseRecording = 0;

	g.contrastFlag = 9; % For counting staircase turning point
	g.contrastFlagTmp = 0; % Initiation
	g.turningCount = 0; % For balance Initiation
	%experimentPars.nTrialInBolck = 2;

	resp.textContrastState = initSetting.contrastStiInit; % Initial contrast level

	for i = 1: experimentPars.nContrastTrial,
		resp.iBlock = i;
		idiomContrast = idiomListShuffled.contrastIdiomList(i, :);
		contrastBlock(initSetting, experimentPars, cfsPars, idiomContrast, experimentFont);

		% Counting turning point
		if g.contrastFlag ~= g.contrastFlagTmp,
			g.turningCount = g.turningCount + 1;
			g.contrastFlag = g.contrastFlagTmp;

			% Cease after reach turing point
			if g.turningCount > experimentPars.turningPoint,
				% Discount starting point
				break
			end


			% Recording lastest 6 turning point
			if g.turningCount > (experimentPars.turningPoint - experimentPars.turningPointExcluding),
				resp.contrastStateRecording(g.turningCount - experimentPars.turningPointExcluding) = resp.contrast{resp.iBlock - 1}.textContrastState;
			end;
		end;

		% Cease after hitting boundary of successive 6 trial
		resp.contrastCeaseRecording(resp.iBlock) =  resp.contrast{resp.iBlock}.textContrastState;
		if resp.iBlock > 6,
			if mean(resp.contrastCeaseRecording(resp.iBlock - 5 : resp.iBlock)) == experimentPars.contrastLowpass || mean(resp.contrastCeaseRecording(resp.iBlock - 5 : resp.iBlock)) <= experimentPars.contrastHighpass,
				break
			end
		end

	end;
	

	% Adjust contrast level
	if length(resp.contrastStateRecording) < 6,
		resp.textContrastState = mean(resp.contrastCeaseRecording(resp.iBlock - 6 : resp.iBlock));
	else
		resp.textContrastState = mean(resp.contrastStateRecording)*0.8;
	end


	% After setting pre-contrast level
	% Instruction to main loop
	experimentFont.textSize = experimentFont.textSizeInstruction;
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);
	c_text = textInstructionList;
	experimentFont.textOffSet = experimentFont.textInstructionOffSet;

	DrawFormattedText(initSetting.windowPtr, c_text.instruction{9}, cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]

	% Only used in Pretest
	%DrawFormattedText(initSetting.windowPtr, 'Pretest end, thank you!', cfsPars.centerDomin(1) - experimentFont.textOffSet, cfsPars.centerNDomin(2) - experimentFont.textOffSet, 0, 40, [], [], 1.5, []); %[, sx][, sy][, color][, wrapat][, flipHorizontal][, flipVertical][, vSpacing][, righttoleft]

	Screen('Flip', initSetting.windowPtr);
	KbQueueWait;
