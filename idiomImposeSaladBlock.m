function idiomImposeSaladBlock(initSetting, experimentPars, cfsPars, idiomList, experimentFont)
	% Set experiment idiom trial,
	for i=1:experimentPars.nTrialInBolck,
		nCharacters = 4; %how many characters in a idiom
		flashCount = 1;
		j = 0;
		while j < nCharacters + 1,
			if j == 0,
				experimentPars.durFrames = experimentPars.durFramesFixP;
				drawFixPointCFS(initSetting, experimentPars, cfsPars);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				initSetting.tvbl = Screen('Flip', initSetting.windowPtr);
				j = j + 1;
			else,
				drawBiMondrians(initSetting, experimentPars, cfsPars);
				%drawMondrians(initSetting, experimentPars, cfsPars);
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerNDomin(1) - experimentFont.toCenter, cfsPars.centerNDomin(2) - experimentFont.toCenter, experimentFont.textColor);
				Screen('DrawText', initSetting.windowPtr, idiomList(i,j), cfsPars.centerDomin(1) - experimentFont.toCenter, cfsPars.centerDomin(2) - experimentFont.toCenter, experimentFont.textColor);
				drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
				%drawFixPointCFS(initSetting, experimentPars, cfsPars);
				if (experimentPars.durFramesCh - cfsPars.durFramesMond*flashCount)/cfsPars.durFramesMond >= 1
					experimentPars.durFrames = cfsPars.durFramesMond;
					flashCount = flashCount + 1;
				else,
					experimentPars.durFrames = mod(experimentPars.durFramesCh, cfsPars.durFramesMond);
					flashCount = 0;
					j = j + 1;
				end;
			end;
			drawHolderFrameCfs(initSetting, experimentPars, cfsPars);
			Screen('DrawingFinished', initSetting.windowPtr);
			initSetting.tvbl = Screen('Flip', initSetting.windowPtr, initSetting.tvbl + initSetting.ifi*(experimentPars.durFrames - 0.5)); %duration - 0.5*initSetting.ifi
		end;
	end;
