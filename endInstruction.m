function endInstruction(initSetting, experimentPars, cfsPars, experimentFont)
	% Making ending instruction

	Screen('TextSize', initSetting.windowPtr, experimentFont.textSizeIBI);
	DrawFormattedText(initSetting.windowPtr, 'End!\nThank you for participation!', cfsPars.centerDomin(1) - ...
		experimentFont.textIBIOffSet, cfsPars.centerNDomin(2) - experimentFont.textIBIOffSet + ...
		experimentFont.testIdiomOffSet, 0, 40, [], [], 1.5, []);
	Screen('Flip', initSetting.windowPtr);
	KbQueueWait;

