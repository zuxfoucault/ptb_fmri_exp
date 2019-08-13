% Practice trial. Record response of character, idiom choices, and iBlock
function idiomImposeBlockPrac(initSetting, experimentPars, cfsPars, idiomList, experimentFont)
	global resp g
	% Set experiment idiom trial,
	Screen('TextSize', initSetting.windowPtr, experimentFont.textSize);

	resp.textContrastState = 0.6; % Initial practice contract value

	resp.practice{resp.iBlock}.bStamp = GetSecs; % Recording block time stamp

	g.tCount = 1;

	% % Synchronizing MRI trigger
	%if experimentPars.mriHook,
	%	while true, %head %recording trigger time

	%		if experimentPars.mri.s2.BytesAvailable ~= 0, % if BytesAvailable will check every loop? %here
	%			keyPress=fread(experimentPars.mri.s2, experimentPars.mri.s2.BytesAvailable, 'uint8');
	%			if keyPress == experimentPars.mri.triggerCode, %remember to set up ignore 53 in get response
	%				tmp = GetSecs;
	%				resp.practice{resp.iBlock}.tbStamp = tmp; % Recording trigger time stamp (block-wise)

	%				resp.practice{resp.iBlock}.tStamp(g.tCount) = tmp; % Recording trigger time stamp (trigger-wise)
	%				g.tCount = g.tCount + 1;
	%				break;
	%			end;
	%		end;

	%	end;
	%end;


	for i=1:experimentPars.nTrialInBolckPrac,
		nCharacters = experimentPars.nCharacters; %how many characters in a idiom
		g.mondCount = 0;
		flashCount = 0;
		j = 0;
		while j < nCharacters + 1,
			if j == 0,
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
				drawFixBiMondrians(initSetting, experimentPars, cfsPars);
				experimentFont.textColor = [repmat(initSetting.black, 1, 3), 255*resp.textContrastState];
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerNDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerDomin(1) - experimentFont.toCenter + experimentFont.toCenterX, cfsPars.centerDomin(2) - experimentFont.toCenter + experimentFont.toCenterY, experimentFont.textColor);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				Screen('DrawingFinished', initSetting.windowPtr);

				[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi
				if flashCount == 0, trialStartTime = initSetting.sot; end;

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
	% flip an blank frame
	[initSetting.tvbl initSetting.sot] = Screen('Flip', initSetting.windowPtr, initSetting.sot + experimentPars.duration - initSetting.ifi*0.5); %duration - 0.5*initSetting.ifi

	textIBIContrast(initSetting, experimentPars, experimentFont, cfsPars);
	resp.practice{resp.iBlock}.character = getResponseMri(experimentPars);
	


	g.testIdiom = idiomList(1,1:4);

	textIBI(initSetting, experimentPars, experimentFont, cfsPars);
	resp.practice{resp.iBlock}.idiom = getResponseMri(experimentPars);
	resp.practice{resp.iBlock}.iBlock = resp.iBlock;
	resp.iBlock = resp.iBlock + 1;
